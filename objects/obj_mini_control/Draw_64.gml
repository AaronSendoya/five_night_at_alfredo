/// @description Dibujar Puntuación y Salida

draw_set_color(c_white);
draw_set_halign(fa_left);

// Texto grande tipo arcade
draw_text_transformed(20, 20, "SCORE: " + string(score), 2, 2, 0);

// Instrucción para salir
draw_set_halign(fa_right);
draw_text(display_get_gui_width() - 20, 20, "ESC para Salir");

// Lógica para Salir (en obj_mini_control)
if (keyboard_check_pressed(vk_escape)) {
    // Coordenadas fijas de retorno (tu fix anterior)
    global.jugador_return_x = 1843;
    global.jugador_return_y = 2302;
    
    // ¡IMPORTANTE! Avisamos que venimos del arcade
    global.skip_intro = true; 
    
    // Volver
    room_goto(rm_oficina_camaras); 
}