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
        draw_set_color(c_black);
        draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
        draw_set_color(c_white);
    } 
    else {
        // OPCIÓN B: JUEGO NORMAL
        draw_surface(application_surface, 0, 0);
    }
    shader_reset();
    
    // ---------------------------------------------------------
    // 2. PANEL SUPERIOR - NOMBRE DE CÁMARA
    // ---------------------------------------------------------
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    // Panel semi-transparente superior
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _w, 80, false);
    draw_set_alpha(1);
    
    // Línea decorativa inferior del panel
    draw_set_color(make_color_rgb(60, 60, 60));
    draw_line_width(0, 80, _w, 80, 2);
    
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
    
    // Nombre de sala con sombra mejorada
    draw_set_color(c_black);
    draw_text(32, 32, _nombre_sala);
    
    draw_set_color(make_color_rgb(220, 220, 220));
    draw_text(30, 30, _nombre_sala);
    
    // ---------------------------------------------------------
    // 3. INDICADOR REC MEJORADO (Parpadeante Suave)
    // ---------------------------------------------------------
    var _pulse = (sin(current_time / 400) + 1) / 2; // Pulsación suave 0-1
    
    if (_pulse > 0.3) { // Solo visible cuando pulse > 0.3
        draw_set_valign(fa_middle);
        
        // Coordenadas del punto rojo
        var _radio = 10;
        var _cx_rojo = _w - 45;
        var _cy_rojo = 40; 
        
        // Glow rojo suave detrás
        draw_set_alpha(_pulse * 0.4);
        draw_set_color(c_red);
        draw_circle(_cx_rojo, _cy_rojo, _radio + 4, false);
        
        // Círculo principal
        draw_set_alpha(_pulse);
        draw_circle(_cx_rojo, _cy_rojo, _radio, false);
        draw_set_alpha(1);
        
        // Texto REC alineado
        var _ancho_texto = string_width("REC");
        var _tx = _cx_rojo - _radio - _ancho_texto - 12;
        var _ty = _cy_rojo;
        
        // Sombra del texto
        draw_set_alpha(_pulse);
        draw_set_color(c_black);
        draw_text(_tx + 2, _ty + 2, "REC");
        
        // Texto principal
        draw_set_color(c_red);
        draw_text(_tx, _ty, "REC");
        draw_set_alpha(1);
        
        draw_set_valign(fa_top);
    }
    
    // ---------------------------------------------------------
    // 4. PANEL INFERIOR - INSTRUCCIONES
    // ---------------------------------------------------------
    // Panel semi-transparente inferior
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, _h - 70, _w, _h, false);
    draw_set_alpha(1);
    
    // Línea decorativa superior del panel
    draw_set_color(make_color_rgb(60, 60, 60));
    draw_line_width(0, _h - 70, _w, _h - 70, 2);
    
    // Instrucciones centradas
    draw_set_halign(fa_center); 
    draw_set_valign(fa_middle); 
    
    var _txt_inst = "< FLECHAS PARA CAMBIAR CAMARA >";
    var _cx = _w / 2;
    var _cy = _h - 35;
    
    // Sombra
    draw_set_color(c_black);
    draw_text(_cx + 2, _cy + 2, _txt_inst);
    
    // Texto principal
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text(_cx, _cy, _txt_inst);
    
    // ---------------------------------------------------------
    // 5. EFECTO DE TRANSICIÓN ENTRE CÁMARAS (OPCIONAL)
    // ---------------------------------------------------------
    // Si acabas de cambiar de cámara, puedes agregar un flash rápido
    // Necesitarías una variable como "camera_transition_timer" en el Create
    
    // Ejemplo (descomentarlo si quieres usarlo):
    /*
    if (camera_transition_timer > 0) {
        camera_transition_timer -= 1;
        var _flash_alpha = camera_transition_timer / 10; // 10 frames de flash
        draw_set_alpha(_flash_alpha);
        draw_set_color(c_white);
        draw_rectangle(0, 0, _w, _h, false);
        draw_set_alpha(1);
    }
    */
    
    // ---------------------------------------------------------
    // 6. DETALLES ADICIONALES - TIMESTAMP Y SEÑAL
    // ---------------------------------------------------------
    // Timestamp en esquina inferior izquierda (estilo cámara de seguridad)
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_pixel_small);
    
    var _timestamp = string(current_hour) + ":" + 
                     string_format(current_minute, 2, 0) + ":" +
                     string_format(floor(current_second), 2, 0);
    
    draw_set_color(c_black);
    draw_text(22, _h - 12, _timestamp);
    
    draw_set_color(make_color_rgb(150, 150, 150));
    draw_text(20, _h - 14, _timestamp);
    
    // Indicador de señal (barras estilo WiFi)
    draw_set_halign(fa_right);
    var _signal_x = _w - 20;
    var _signal_y = _h - 25;
    
    draw_set_color(make_color_rgb(100, 100, 100));
    draw_rectangle(_signal_x - 15, _signal_y, _signal_x - 12, _signal_y + 8, false);
    draw_rectangle(_signal_x - 10, _signal_y - 3, _signal_x - 7, _signal_y + 8, false);
    draw_rectangle(_signal_x - 5, _signal_y - 6, _signal_x - 2, _signal_y + 8, false);
    
    // ---------------------------------------------------------
    // RESTAURAR VALORES POR DEFECTO
    // ---------------------------------------------------------
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1); 
    draw_set_color(c_white);
}