if (global.en_camaras) {
    
    // ---------------------------------------------------------
    // 1. DIBUJAR EL JUEGO CON EFECTO CRT (Monitor Viejo)
    // ---------------------------------------------------------
    shader_set(shd_monitor_crt);
    
    // Pasar uniformes (tiempo y resolución)
    tiempo_shader += 0.01;
    var _u_time = shader_get_uniform(shd_monitor_crt, "u_time");
    shader_set_uniform_f(_u_time, tiempo_shader);
    
    var _u_res = shader_get_uniform(shd_monitor_crt, "u_resolution");
    shader_set_uniform_f(_u_res, display_get_gui_width(), display_get_gui_height());
    
    
    if (interferencia == true) {
        // OPCIÓN A: SEÑAL PERDIDA (Pantalla negra con estática)
        // Dibujamos un cuadro negro. El shader le pondrá "grano" encima automáticamente.
        draw_set_color(c_black);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
        draw_set_color(c_white); // Resetear color
    } 
    else {
        // OPCIÓN B: JUEGO NORMAL
        draw_surface(application_surface, 0, 0);
    }

    shader_reset();


    // ---------------------------------------------------------
    // 2. DIBUJAR LA INTERFAZ (UI) - TEXTO GRANDE Y CLARO
    // ---------------------------------------------------------

    // Usar la fuente grande
    draw_set_font(fnt_camara_osd);
    
    draw_set_halign(fa_left); 
    draw_set_valign(fa_top); 

    var _nombre_sala = "";
    switch (camara_actual) {
        case 0: _nombre_sala = "CAM 01: COMEDOR"; break;
        case 1: _nombre_sala = "CAM 02: MANTENIMIENTO"; break;
        case 2: _nombre_sala = "CAM 03: COCINA"; break;
        case 3: _nombre_sala = "CAM 04: ARCADE"; break;
        case 4: _nombre_sala = "CAM 05: ALMACEN"; break;
        case 5: _nombre_sala = "CAM 06: ESCENARIO"; break;
    }

    // --- A. NOMBRE DE SALA (Con Sombra) ---
    draw_set_color(c_black);
    draw_text(32, 32, _nombre_sala); // Sombra
    draw_set_color(c_white);
    draw_text(30, 30, _nombre_sala); // Texto real

    // --- B. PUNTO ROJO REC (Ajuste Automático) ---
    if (current_time % 1000 < 500) { 
        
        // Truco: Alineación vertical al centro para que cuadre fácil
        draw_set_valign(fa_middle);

        // Coordenadas del punto rojo
        var _radio = 12;
        var _cx_rojo = display_get_gui_width() - 40;
        var _cy_rojo = 35; 

        // Dibujar Círculo
        draw_set_color(c_red);
        draw_circle(_cx_rojo, _cy_rojo, _radio, false);
        
        // Calcular dónde poner el texto para que no choque
        var _ancho_texto = string_width("REC");
        var _tx = _cx_rojo - _radio - _ancho_texto - 10; // 10px de separación
        var _ty = _cy_rojo; // Misma altura que el círculo

        // Dibujar Texto REC
        draw_set_color(c_black);
        draw_text(_tx + 2, _ty + 2, "REC"); // Sombra
        draw_set_color(c_white);
        draw_text(_tx, _ty, "REC"); // Real

        // Restaurar alineación
        draw_set_valign(fa_top);
    }

    // --- C. INSTRUCCIONES (Abajo Centro) ---
    draw_set_halign(fa_center); 
    draw_set_valign(fa_bottom); 
    
    var _txt_inst = "< Flechas para cambiar >";
    var _cx = display_get_gui_width()/2;
    var _cy = display_get_gui_height() - 30;

    draw_set_color(c_black);
    draw_text(_cx + 2, _cy + 2, _txt_inst); 
    draw_set_color(c_white);
    draw_text(_cx, _cy, _txt_inst);      
    
    // --- RESTAURAR VALORES ---
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1); 
    draw_set_color(c_white);
}