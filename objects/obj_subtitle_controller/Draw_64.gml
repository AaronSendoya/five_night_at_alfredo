/// @description Dibujar subtítulos

if (indice_actual < array_length(subtitulos)) {
    var texto = subtitulos[indice_actual];
    
    // Configuración de la caja de subtítulos
    var caja_altura = 120;
    var caja_y = display_get_gui_height() - caja_altura - 20;
    var caja_ancho = display_get_gui_width() - 100;
    var caja_x = 50;
    
    // Dibujar fondo semi-transparente
    draw_set_alpha(0.7 * alpha_subtitulo);
    draw_set_color(c_black);
    draw_rectangle(caja_x, caja_y, caja_x + caja_ancho, caja_y + caja_altura, false);
    
    // Dibujar borde
    draw_set_alpha(0.9 * alpha_subtitulo);
    draw_set_color(c_white);
    draw_rectangle(caja_x, caja_y, caja_x + caja_ancho, caja_y + caja_altura, true);
    
    // Dibujar texto más grande
    draw_set_alpha(alpha_subtitulo);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Usar draw_text_ext_transformed para texto escalado
    var escala = 2;  // Cambia este número para ajustar el tamaño
    draw_text_ext_transformed(
        caja_x + caja_ancho/2, 
        caja_y + caja_altura/2, 
        texto,
        -1,
        (caja_ancho - 40) / escala,
        escala,         // Escala horizontal
        escala,         // Escala vertical
        0               // Rotación
    );
    
    // Resetear configuración
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}