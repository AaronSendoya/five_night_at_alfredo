/// @description Pintar el cuadro negro

// Configurar color negro
draw_set_color(c_black);
// Configurar transparencia según la variable alpha
draw_set_alpha(alpha);

// Dibujar un rectángulo que cubra TODA la pantalla
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// RESTABLECER (Muy importante para no afectar al resto del juego)
draw_set_alpha(1);
draw_set_color(c_white);