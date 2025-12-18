/// @description DIBUJAR MAPA CON SHADER Y ICONOS MEJORADOS

// Actualizar timer para el shader
time_counter += 0.01;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// ==========================================================
// 1. FONDO OSCURO CON VIÑETA (Efecto de Profundidad)
// ==========================================================
draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// Viñeta en los bordes
draw_set_alpha(0.4);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, 60, false); // Superior
draw_rectangle(0, gui_h - 60, gui_w, gui_h, false); // Inferior
draw_rectangle(0, 0, 50, gui_h, false); // Izquierda
draw_rectangle(gui_w - 50, 0, gui_w, gui_h, false); // Derecha
draw_set_alpha(1);

// ==========================================================
// 2. ACTIVAR SHADER CRT (Monitor Viejo)
// ==========================================================
shader_set(shd_monitor_crt); 
var _u_time = shader_get_uniform(shd_monitor_crt, "u_time");
shader_set_uniform_f(_u_time, time_counter);

var _u_res = shader_get_uniform(shd_monitor_crt, "u_resolution");
shader_set_uniform_f(_u_res, gui_w, gui_h);

// ==========================================================
// 3. DIBUJAR EL PLANO (BLUEPRINT) - MÁS BRILLANTE
// ==========================================================
draw_sprite_stretched_ext(
    spr_mapa_blueprint, 0, 
    map_x1, map_y1, 
    map_display_size, map_display_size,
    c_white, 0.9 // Más brillante (antes era c_ltgray con alpha 1)
);

// ==========================================================
// 4. APAGAR SHADER (Para dibujar iconos sin distorsión)
// ==========================================================
shader_reset();

// ==========================================================
// 5. SCANLINES SUTILES (Efecto CRT Manual)
// ==========================================================
draw_set_alpha(0.12);
for (var i = 0; i < gui_h; i += 3) {
    draw_set_color(c_black);
    draw_line(0, i, gui_w, i);
}
draw_set_alpha(1);

// ==========================================================
// 6. DIBUJAR ICONOS DE VENTILACIONES (MEJORADOS)
// ==========================================================
with (obj_ventilation) {
    
    // Calcular posición en el mapa
    var _pct_x = x / other.world_width_max;
    var _pct_y = y / other.world_height_max;
    
    var _draw_x = other.map_x1 + (_pct_x * other.map_display_size);
    var _draw_y = other.map_y1 + (_pct_y * other.map_display_size);
    
    // Detección de mouse (MEJORADA - Radio más grande)
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _hover = point_distance(_mouse_gui_x, _mouse_gui_y, _draw_x, _draw_y) < 40; // Radio 40px
    
    // Variables de visualización
    var _scale = 1.0;
    var _col = make_color_rgb(100, 200, 200); // Cyan apagado por defecto
    var _alpha = 0.8;
    var _glow_alpha = 0;
    
    // ======================================================
    // ESTADO 1: UBICACIÓN ACTUAL DEL JUGADOR
    // ======================================================
    if (id == global.current_vent_id) {
        _col = make_color_rgb(255, 160, 60); // Naranja brillante
        _scale = 1.3;
        _alpha = 1;
        
        // Efecto de pulsación
        var _pulse = 1 + (sin(current_time / 180) * 0.15);
        _scale *= _pulse;
        
        // Glow naranja pulsante
        _glow_alpha = 0.4 + (sin(current_time / 180) * 0.2);
    }
    
    // ======================================================
    // ESTADO 2: MOUSE ENCIMA (Hover)
    // ======================================================
    else if (_hover) {
        _col = make_color_rgb(120, 255, 120); // Verde brillante
        _scale = 1.5;
        _alpha = 1;
        _glow_alpha = 0.5;
        
        // Click para teletransportarse
        if (mouse_check_button_pressed(mb_left)) {
            var _safe_x = x + lengthdir_x(exit_distance, exit_angle);
            var _safe_y = y + lengthdir_y(exit_distance, exit_angle);
            
            obj_jugador.x = _safe_x;
            obj_jugador.y = _safe_y;
            obj_jugador.visible = true;
            global.player_hidden = false;
            instance_destroy(other);
        }
    }
    
    // ======================================================
    // ESTADO 3: Normal (Sin hover, no es tu posición)
    // ======================================================
    else {
        _glow_alpha = 0.15; // Glow muy sutil
    }
    
    // ======================================================
    // DIBUJAR GLOW (Círculo Brillante)
    // ======================================================
    if (_glow_alpha > 0) {
        draw_set_alpha(_glow_alpha);
        draw_set_color(_col);
        draw_circle(_draw_x, _draw_y, 35 * _scale, false);
        draw_set_alpha(1);
    }
    
    // ======================================================
    // DIBUJAR CONTORNO NEGRO (Silueta)
    // ======================================================
    draw_sprite_ext(
        spr_icon_vent, 0, 
        _draw_x, _draw_y, 
        _scale * 1.15, _scale * 1.15, 
        0, c_black, _alpha * 0.8
    );
    
    // ======================================================
    // DIBUJAR ICONO PRINCIPAL (Color)
    // ======================================================
    draw_set_alpha(_alpha);
    draw_sprite_ext(
        spr_icon_vent, 0, 
        _draw_x, _draw_y, 
        _scale, _scale, 
        0, _col, 1
    );
    draw_set_alpha(1);
    
    // ======================================================
    // LÍNEAS DE CONEXIÓN (Opcional - Visual Extra)
    // ======================================================
    if (id == global.current_vent_id) {
        // Guardar variables del UI en variables locales
        var _ui_world_w = other.world_width_max;
        var _ui_world_h = other.world_height_max;
        var _ui_map_x1 = other.map_x1;
        var _ui_map_y1 = other.map_y1;
        var _ui_map_size = other.map_display_size;
        var _origin_draw_x = _draw_x;
        var _origin_draw_y = _draw_y;
        
        // Dibuja líneas punteadas hacia ventilaciones cercanas
        with (obj_ventilation) {
            if (id != other.id) {
                var _dist = point_distance(x, y, other.x, other.y);
                if (_dist < 800) { // Solo conectar si están cerca
                    var _target_pct_x = x / _ui_world_w;
                    var _target_pct_y = y / _ui_world_h;
                    var _target_draw_x = _ui_map_x1 + (_target_pct_x * _ui_map_size);
                    var _target_draw_y = _ui_map_y1 + (_target_pct_y * _ui_map_size);
                    
                    draw_set_alpha(0.25);
                    draw_set_color(make_color_rgb(80, 150, 150));
                    
                    // Línea punteada
                    var _segments = 10;
                    for (var s = 0; s < _segments; s += 2) {
                        var _t1 = s / _segments;
                        var _t2 = (s + 1) / _segments;
                        var _x1 = lerp(_origin_draw_x, _target_draw_x, _t1);
                        var _y1 = lerp(_origin_draw_y, _target_draw_y, _t1);
                        var _x2 = lerp(_origin_draw_x, _target_draw_x, _t2);
                        var _y2 = lerp(_origin_draw_y, _target_draw_y, _t2);
                        draw_line_width(_x1, _y1, _x2, _y2, 1);
                    }
                    draw_set_alpha(1);
                }
            }
        }
    }
}

// ==========================================================
// 7. DIBUJAR JUGADOR (Si está visible en el mundo)
// ==========================================================
if (instance_exists(obj_jugador) && obj_jugador.visible) {
    var _p_pct_x = obj_jugador.x / world_width_max;
    var _p_pct_y = obj_jugador.y / world_height_max;
    var _p_draw_x = map_x1 + (_p_pct_x * map_display_size);
    var _p_draw_y = map_y1 + (_p_pct_y * map_display_size);
    
    // Glow magenta
    draw_set_alpha(0.4);
    draw_set_color(c_fuchsia);
    draw_circle(_p_draw_x, _p_draw_y, 25, false);
    draw_set_alpha(1);
    
    // Contorno negro
    draw_sprite_ext(
        spr_map_icons, 0, 
        _p_draw_x, _p_draw_y, 
        1.2, 1.2, 
        obj_jugador.direction, c_black, 1
    );
    
    // Icono magenta brillante
    draw_sprite_ext(
        spr_map_icons, 0, 
        _p_draw_x, _p_draw_y, 
        1.0, 1.0, 
        obj_jugador.direction, c_fuchsia, 1
    );
}

// ==========================================================
// 8. MARCO DEL MAPA (Borde Decorativo)
// ==========================================================
draw_set_color(make_color_rgb(60, 120, 120));
draw_rectangle(map_x1 - 3, map_y1 - 3, map_x1 + map_display_size + 3, map_y1 + map_display_size + 3, true);

draw_set_color(make_color_rgb(40, 80, 80));
draw_rectangle(map_x1 - 5, map_y1 - 5, map_x1 + map_display_size + 5, map_y1 + map_display_size + 5, true);

// ==========================================================
// 9. PANEL INFERIOR - INSTRUCCIONES
// ==========================================================
var _panel_y = map_y1 + map_display_size + 15;

// Fondo del panel
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(map_x1 - 5, _panel_y, map_x1 + map_display_size + 5, _panel_y + 50, false);
draw_set_alpha(1);

// Línea superior del panel
draw_set_color(make_color_rgb(60, 120, 120));
draw_line_width(map_x1 - 5, _panel_y, map_x1 + map_display_size + 5, _panel_y, 2);

// Texto centrado
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// "SYSTEM ONLINE"
draw_set_color(c_black);
draw_text(gui_w / 2 + 1, _panel_y + 16, "SYSTEM ONLINE");

draw_set_color(make_color_rgb(100, 220, 220));
draw_text(gui_w / 2, _panel_y + 15, "SYSTEM ONLINE");

// "[E] CLOSE MAP"
draw_set_color(c_black);
draw_text(gui_w / 2 + 1, _panel_y + 36, "[E] CLOSE MAP");

draw_set_color(make_color_rgb(180, 180, 180));
draw_text(gui_w / 2, _panel_y + 35, "[E] CLOSE MAP");

// ==========================================================
// 10. TÍTULO SUPERIOR - "VENTILATION SYSTEM"
// ==========================================================
var _title_y = map_y1 - 35;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Sombra
draw_set_color(c_black);
draw_text(gui_w / 2 + 2, _title_y + 2, "VENTILATION SYSTEM");

// Texto principal
draw_set_color(make_color_rgb(100, 220, 220));
draw_text(gui_w / 2, _title_y, "VENTILATION SYSTEM");

// ==========================================================
// RESETEAR PROPIEDADES
// ==========================================================
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);