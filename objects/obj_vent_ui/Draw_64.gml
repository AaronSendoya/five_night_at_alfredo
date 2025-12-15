/// @description DIBUJAR MAPA CON SHADER Y ICONOS VISIBLES

// Actualizar timer para el shader
time_counter += 0.01;

// 1. FONDO OSCURO (Detrás de la tablet)
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// =========================================================
// 2. ACTIVAR EL MODO MONITOR VIEJO (SHADER)
// =========================================================
// Asegúrate que el nombre del shader coincida aquí
shader_set(shd_monitor_crt); 
var _u_time = shader_get_uniform(shd_monitor_crt, "u_time");
shader_set_uniform_f(_u_time, time_counter);

// A. DIBUJAR EL PLANO (BLUEPRINT)
// Lo dibujamos un poco más oscuro (c_gray) para que los iconos brillen más encima
draw_sprite_stretched_ext(
    spr_mapa_blueprint, 0, 
    map_x1, map_y1, 
    map_display_size, map_display_size,
    c_ltgray, 1 
);

// =========================================================
// B. DIBUJAR ICONOS (POTENCIADOS)
// =========================================================

// --- DIBUJAR VENTILACIONES ---
with (obj_ventilation) {
    
    // MATEMÁTICA DE ESCALA
    var _pct_x = x / other.world_width_max;
    var _pct_y = y / other.world_height_max;
    
    var _draw_x = other.map_x1 + (_pct_x * other.map_display_size);
    var _draw_y = other.map_y1 + (_pct_y * other.map_display_size);
    
    // Lógica del Mouse
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _hover = point_distance(_mouse_gui_x, _mouse_gui_y, _draw_x, _draw_y) < 30; // Aumenté el radio de detección
    
    var _subimg = 1; // Frame 1 = Rejilla
    
    // --- MEJORA 1: ESCALA BASE MÁS GRANDE ---
    var _scale = 3.0; // Antes era 2.0, ahora son más grandes por defecto
    var _col = c_aqua; // Color base cyan brillante
    
    // --- ESTADO: TU UBICACIÓN ACTUAL ---
    if (id == global.current_vent_id) {
        _subimg = 2; // Frame 2 = Target
        _col = c_orange; // Naranja destaca mucho sobre azul
        
        // --- MEJORA 2: EFECTO DE PALPITACIÓN ---
        // Usamos seno del tiempo para que se agrande y achique
        var _pulse = 1 + sin(current_time / 150) * 0.2; 
        _scale = 3.5 * _pulse; 
    }
    
    // --- ESTADO: MOUSE ENCIMA ---
    if (_hover) {
        _scale = 4.0; // Muy grande al seleccionar
        _col = c_lime; // Verde semáforo
        
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
    
    // --- MEJORA 3: CONTORNO NEGRO (SILUETA) ---
    // Dibujamos el mismo icono en NEGRO y un poco más grande atrás.
    // Esto crea un borde que lo separa de las líneas del mapa.
    draw_sprite_ext(spr_map_icons, _subimg, _draw_x, _draw_y, _scale * 1.2, _scale * 1.2, 0, c_black, 1);
    
    // DIBUJAR EL ICONO REAL (COLOR)
    draw_sprite_ext(spr_map_icons, _subimg, _draw_x, _draw_y, _scale, _scale, 0, _col, 1);
}

// --- DIBUJAR JUGADOR (SI QUISIERAS) ---
if (instance_exists(obj_jugador)) {
    var _p_pct_x = obj_jugador.x / world_width_max;
    var _p_pct_y = obj_jugador.y / world_height_max;
    var _p_draw_x = map_x1 + (_p_pct_x * map_display_size);
    var _p_draw_y = map_y1 + (_p_pct_y * map_display_size);
    
    // Contorno negro para el jugador
    draw_sprite_ext(spr_map_icons, 0, _p_draw_x, _p_draw_y, 3.5, 3.5, obj_jugador.direction, c_black, 1);
    // Icono magenta brillante
    draw_sprite_ext(spr_map_icons, 0, _p_draw_x, _p_draw_y, 3.0, 3.0, obj_jugador.direction, c_fuchsia, 1);
}

// =========================================================
// 3. APAGAR EL SHADER
// =========================================================
shader_reset();

// 4. MARCO Y TEXTO
draw_set_color(c_dkgray);
draw_rectangle(map_x1 - 5, map_y1 - 5, map_x1 + map_display_size + 5, map_y1 + map_display_size + 5, true);

draw_set_halign(fa_center);
draw_text(gui_w / 2, map_y1 + map_display_size + 20, "SYSTEM ONLINE - [E] EXIT");
draw_set_halign(fa_left);