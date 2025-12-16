/// @description Dibujar menú

// Dibujar el fondo
draw_sprite_stretched(sp_fondo_menu_principal, 0, 0, 0, 
    display_get_gui_width(), display_get_gui_height());

// Configurar texto
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);

// Efecto de brillo/sombra si el mouse está encima
if (mouse_sobre_play && brillo_alpha > 0) {
    draw_set_alpha(brillo_alpha * 0.5);
    draw_set_color(c_yellow);
    
    // Dibujar sombra brillante
    for (var i = 0; i < 4; i++) {
        var offset = 4;
        draw_text_transformed(
            play_x + offset * dcos(i * 90),
            play_y + offset * dsin(i * 90),
            "PLAY",
            escala_play,
            escala_play,
            0
        );
    }
}

// Dibujar texto PLAY principal
draw_set_alpha(1);
draw_set_color(color_actual);
draw_text_transformed(
    play_x,
    play_y,
    "PLAY",
    escala_play,
    escala_play,
    0
);

// Resetear configuración
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);