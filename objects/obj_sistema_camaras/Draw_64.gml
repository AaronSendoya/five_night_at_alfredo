if (global.en_camaras) {

    // --- 1. DIBUJAR EL FONDO DE LA HABITACIÓN ---
    var _sprite_a_dibujar = noone;
    var _nombre_sala = "";

    switch (camara_actual) {
        case 0: 
            _sprite_a_dibujar = sp_pizzeria_comedor;
            _nombre_sala = "CAM 01: COMEDOR";
            break;
        case 1:
            _sprite_a_dibujar = sp_fondo_deposito; 
            _nombre_sala = "CAM 02: MANTENIMIENTO";
            break;
    }

    // Dibujar el fondo estirado a toda la pantalla
    if (_sprite_a_dibujar != noone) {
        draw_sprite_stretched(_sprite_a_dibujar, 0, 0, 0, display_get_gui_width(), display_get_gui_height());
    }

    // --- 2. DIBUJAR INTERFAZ (UI) ---

    // Texto de la cámara (arriba izquierda)
    draw_set_color(c_white);
    draw_text(30, 30, _nombre_sala);

    // Punto rojo de "REC" (parpadeando)
    if (current_time % 1000 < 500) { // Parpadea cada medio segundo
        draw_set_color(c_red);
        draw_circle(display_get_gui_width() - 50, 50, 10, false);
        draw_set_color(c_white);
        draw_text(display_get_gui_width() - 90, 40, "REC");
    }

    // Instrucciones
    draw_text(display_get_gui_width()/2 - 100, display_get_gui_height() - 50, "< Flechas para cambiar >");
}