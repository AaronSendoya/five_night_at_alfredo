/// @description Texto "Presiona E" en pantalla

// Solo mostramos el texto si estamos cerca Y el mapa NO está abierto
if (mostrar_mensaje && !instance_exists(obj_vent_ui)) {
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    
    // Usar tu fuente personalizada si existe
    if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso);
    
    var _cx = display_get_gui_width() / 2;
    var _cy = display_get_gui_height() - 50;
    
    // Texto con sombra
    draw_set_color(c_black);
    draw_text(_cx + 2, _cy + 2, "Presiona [E] para Entrar");
    
    draw_set_color(c_white);
    draw_text(_cx, _cy, "Presiona [E] para Entrar");
    
    // Resetear configuración de dibujo
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}