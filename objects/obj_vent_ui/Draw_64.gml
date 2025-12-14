/// @description DIBUJAR EL MAPA Y LOGICA DE TELETRANSPORTE

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 1. Fondo Oscuro
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// 2. El Monitor
draw_set_color(c_dkgray);
draw_rectangle(map_x1 - 5, map_y1 - 5, map_x2 + 5, map_y2 + 5, false); 
draw_set_color(c_black);
draw_rectangle(map_x1, map_y1, map_x2, map_y2, false); 

// Título
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(gui_w / 2, map_y1 - 30, "SISTEMA DE VENTILACION");

// =========================================================
// 3. LOGICA DE PUNTOS Y CLICS
// =========================================================

// Usamos 'obj_ventilation' (Con T)
with (obj_ventilation) { 
    
    var _rel_x = x / room_width;
    var _rel_y = y / room_height;
    
    var _draw_x = other.map_x1 + (_rel_x * other.map_width);
    var _draw_y = other.map_y1 + (_rel_y * other.map_height);
    
    var _color = c_lime;
    var _scale = 1.0;
    
    if (id == global.current_vent_id) {
        _color = c_yellow;
        draw_text(_draw_x, _draw_y - 20, "TU");
    }
    
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _hover = point_distance(_mouse_gui_x, _mouse_gui_y, _draw_x, _draw_y) < 20;
    
    if (_hover) {
        _scale = 1.5; 
        _color = c_white;
        
        // --- TELETRANSPORTE ---
        if (mouse_check_button_pressed(mb_left)) {
            
            // 1. CÁLCULO DE POSICIÓN SEGURA (70px)
            var _safe_x = x + lengthdir_x(exit_distance, exit_angle);
            var _safe_y = y + lengthdir_y(exit_distance, exit_angle);
            
            // 2. MOVER JUGADOR
            obj_jugador.x = _safe_x;
            obj_jugador.y = _safe_y; 
            
            // 3. REAPARECER Y QUITAR INVISIBILIDAD
            obj_jugador.visible = true;
            global.player_hidden = false; // ¡ANIMATRÓNICOS PUEDEN VERME DE NUEVO!
            
            // 4. CERRAR
            instance_destroy(other); 
        }
    }
    
    draw_sprite_ext(spr_icon_vent, 0, _draw_x, _draw_y, _scale, _scale, 0, _color, 1);
}

// Botón cancelar
draw_set_halign(fa_center);
draw_text(gui_w / 2, map_y2 + 20, "PRESIONA [E] PARA SALIR");
draw_set_halign(fa_left);