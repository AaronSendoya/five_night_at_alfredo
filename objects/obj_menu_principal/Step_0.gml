/// @description Lógica del menú

// Obtener posición del mouse en la GUI
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Calcular el área del texto PLAY (aproximado)
var texto_ancho = string_width("PLAY") * escala_play;
var texto_alto = string_height("PLAY") * escala_play;

// Verificar si el mouse está sobre PLAY
if (point_in_rectangle(mx, my, 
    play_x - texto_ancho/2, 
    play_y - texto_alto/2,
    play_x + texto_ancho/2, 
    play_y + texto_alto/2)) {
    
    mouse_sobre_play = true;
    escala_objetivo = 3.3;  // Hacer el texto un poco más grande
    
    // Si hace clic, ir al tutorial
    if (mouse_check_button_pressed(mb_left)) {
        // Cambia "rm_tutorial" por el nombre de tu room de tutorial
        room_goto(rm_menu_principal);
    }
    
} else {
    mouse_sobre_play = false;
    escala_objetivo = 3;
}

// Suavizar la transición de escala
escala_play = lerp(escala_play, escala_objetivo, 0.2);

// Suavizar la transición de color
if (mouse_sobre_play) {
    color_actual = merge_color(color_actual, color_hover, 0.2);
    brillo_alpha += brillo_speed;
    if (brillo_alpha > 1) brillo_alpha = 0;
} else {
    color_actual = merge_color(color_actual, color_normal, 0.2);
    brillo_alpha = 0;
}