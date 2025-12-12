if (global.en_camaras) {

    // --- 1. DEFINIR EL NOMBRE DE LA SALA ---
    // Ya no elegimos sprites, solo necesitamos saber el nombre para el texto
    var _nombre_sala = "";

    switch (camara_actual) {
        case 0: _nombre_sala = "CAM 01: COMEDOR"; break;
        case 1: _nombre_sala = "CAM 02: MANTENIMIENTO"; break;
        case 2: _nombre_sala = "CAM 03: COCINA"; break;
        case 3: _nombre_sala = "CAM 04: ARCADE"; break;
        case 4: _nombre_sala = "CAM 05: ALMACEN"; break;
        case 5: _nombre_sala = "CAM 06: ESCENARIO"; break;
    }

    // ¡BORRAMOS LA PARTE DE "draw_sprite_stretched"! 
    // Ahora vemos el juego real a través del Viewport.

    // --- 2. DIBUJAR INTERFAZ (UI) ---
    // Esto se dibuja ENCIMA de lo que ve la cámara

    // Configuración de texto
    draw_set_halign(fa_left); 
    draw_set_color(c_white);
    
    // Nombre de la sala (Arriba izquierda)
    draw_text(30, 30, _nombre_sala);

    // Punto rojo de "REC" (Parpadea cada medio segundo)
    if (current_time % 1000 < 500) { 
        draw_set_color(c_red);
        draw_circle(display_get_gui_width() - 50, 50, 10, false);
        draw_set_color(c_white);
        draw_text(display_get_gui_width() - 90, 40, "REC");
    }

    // Instrucciones (Abajo centro)
    draw_set_halign(fa_center); 
    draw_text(display_get_gui_width()/2, display_get_gui_height() - 50, "< Flechas para cambiar >");
    
    // RESTAURAR ALINEACIÓN (Importante para no romper otros textos)
    draw_set_halign(fa_left); 
    draw_set_color(c_white);
}