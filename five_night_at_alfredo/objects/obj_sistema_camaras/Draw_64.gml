if (global.en_camaras) {

    // --- 1. SELECCIONAR QUÉ FONDO DIBUJAR ---
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
        case 2:
            _sprite_a_dibujar = sp_fondo_cocina; 
            _nombre_sala = "CAM 03: COCINA";
            break;
        case 3:
            _sprite_a_dibujar = sp_fondo_arcade; 
            _nombre_sala = "CAM 04: ARCADE";
            break;
        case 4:
            _sprite_a_dibujar = sp_fondo_almacen; 
            _nombre_sala = "CAM 05: ALMACEN";
            break;
        case 5:
            _sprite_a_dibujar = sp_escenario_principal; 
            _nombre_sala = "CAM 06: ESCENARIO";
            break;
    }

    // --- 2. DIBUJAR EL FONDO ---
    // Estiramos la imagen para que ocupe toda la pantalla
    if (_sprite_a_dibujar != noone) {
        draw_sprite_stretched(_sprite_a_dibujar, 0, 0, 0, display_get_gui_width(), display_get_gui_height());
    }

    // (AQUÍ QUITAMOS LA PARTE DE FREDDY/ENEMIGOS PARA QUE NO TE DE ERROR)

    // --- 3. DIBUJAR INTERFAZ (UI) ---

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
    draw_set_halign(fa_left); // Restaurar alineación
}