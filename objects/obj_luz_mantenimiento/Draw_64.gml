/// @description Dibujar el efecto

if (alpha > 0) {
    draw_set_color(c_black);
    draw_set_alpha(alpha);
    
    // Dibuja un rectángulo negro que cubre toda la pantalla
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // Restablecer para no afectar a otros dibujos
    draw_set_alpha(1);
    draw_set_color(c_white);
}