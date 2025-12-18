/// @description UI Batería (Izquierda y Grande)

if (has_flashlight) {
    
    // --- POSICIÓN: ARRIBA IZQUIERDA ---
    var _x = 50;  
    var _y = 50;  
    
    // ESCALA: Grande (3x)
    var _scale = 3; 

    // Lógica del frame (Verde/Amarillo/Rojo)
    var _pct = battery_level / battery_max;
    var _subimg = 3; // Vacío por defecto
    
    if (_pct > 0.50) _subimg = 0;      // Verde
    else if (_pct > 0.20) _subimg = 1; // Amarillo
    else if (_pct > 0.0) _subimg = 2;  // Rojo

    // Dibujar Icono
    draw_sprite_ext(spr_bateria_ui, _subimg, _x, _y, _scale, _scale, 0, c_white, 1);

    // Barra de carga (Feedback visual al recargar)
    if (is_cranking) {
        draw_set_color(c_lime);
        // Barra debajo del icono
        draw_rectangle(_x - 20, _y + 60, _x - 20 + (50 * _pct), _y + 70, false);
        draw_set_color(c_white);
    }
}
// --- MENSAJE DE INSTRUCCIÓN (AMARILLO) ---

// --- MENSAJE DE INSTRUCCIÓN (CON FUENTE fnt_camara_osd) ---
if (msg_timer > 0) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // CAMBIO: Asignamos tu fuente específica
    if (font_exists(asset_get_index("fnt_camara_osd"))) {
        draw_set_font(asset_get_index("fnt_camara_osd"));
    }
    
    // TEXTO Y POSICIÓN
    var _txt = "MANTEN [ESPACIO] PARA RECARGAR";
    var _tx = _gui_w / 2;
    var _ty = _gui_h - 150;
    
    // ESCALA: Grande (3x) + Efecto de respiración
    var _scale = 1.5 + (sin(current_time / 200) * 0.2); 
    
    // 1. SOMBRA NEGRA (Para contraste total)
    draw_set_color(c_black);
    draw_set_alpha(1);
    // Desplazamos 4 pixeles para la sombra
    draw_text_transformed(_tx + 4, _ty + 4, _txt, _scale, _scale, 0);
    
    // 2. TEXTO PRINCIPAL (AMARILLO)
    // Parpadeo suave entre amarillo y blanco
    var _col_mix = merge_color(c_yellow, c_white, (sin(current_time / 100) + 1) / 2);
    
    draw_set_color(_col_mix);
    draw_text_transformed(_tx, _ty, _txt, _scale, _scale, 0);
    
    // RESTAURAR CONFIGURACIÓN
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1); // Reseteamos la fuente para no afectar otros menús
}