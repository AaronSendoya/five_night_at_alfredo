if (global.en_camaras) {
    
    // Obtener dimensiones PRIMERO (necesarias para todo)
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    // ---------------------------------------------------------
    // 1. DIBUJAR EL JUEGO CON EFECTO CRT (Monitor Viejo)
    // ---------------------------------------------------------
    shader_set(shd_monitor_crt);
    
    // Pasar uniformes (tiempo y resolución)
    tiempo_shader += 0.01;
    var _u_time = shader_get_uniform(shd_monitor_crt, "u_time");
    shader_set_uniform_f(_u_time, tiempo_shader);
    
    var _u_res = shader_get_uniform(shd_monitor_crt, "u_resolution");
    shader_set_uniform_f(_u_res, _w, _h);
    
    
    if (interferencia == true) {
        // OPCIÓN A: SEÑAL PERDIDA (Pantalla negra con estática)
        draw_set_color(c_black);
        draw_rectangle(0, 0, _w, _h, false);
        draw_set_color(c_white);
    } 
    else {
        // OPCIÓN B: JUEGO NORMAL
        draw_surface(application_surface, 0, 0);
    }
    shader_reset();
    
    // ---------------------------------------------------------
    // 1.5. EFECTO DE INTERFERENCIA TV ANALÓGICA
    // ---------------------------------------------------------
    // Líneas de escaneo horizontales (scanlines) - PERMANENTES
    draw_set_alpha(0.15);
    for (var i = 0; i < _h; i += 4) {
        draw_set_color(c_black);
        draw_line_width(0, i, _w, i, 1);
    }
    draw_set_alpha(1);
    
    // Ruido/estática SUTIL permanente (background noise)
    repeat(15) {
        var _rx = irandom(_w);
        var _ry = irandom(_h);
        draw_set_alpha(random_range(0.05, 0.15));
        draw_set_color(make_color_rgb(
            irandom_range(180, 220),
            irandom_range(180, 220),
            irandom_range(180, 220)
        ));
        draw_circle(_rx, _ry, 1, false);
    }
    draw_set_alpha(1);
    
    // ---------------------------------------------------------
    // RUIDO INTENSO ALEATORIO TEMPORAL (Nuevo Sistema)
    // ---------------------------------------------------------
    // Verificar si debe activarse el ruido intenso
    if (!variable_instance_exists(id, "noise_burst_active")) {
        noise_burst_active = false;
        noise_burst_timer = 0;
        next_noise_burst = irandom_range(180, 420); // Entre 3-7 segundos (a 60fps)
    }
    
    // Contador para el próximo burst
    if (!noise_burst_active) {
        next_noise_burst--;
        
        if (next_noise_burst <= 0) {
            // ¡ACTIVAR RUIDO INTENSO!
            noise_burst_active = true;
            noise_burst_timer = irandom_range(8, 25); // Dura entre 8-25 frames (muy rápido)
            next_noise_burst = irandom_range(180, 420); // Resetear para el próximo
        }
    }
    
    // Si el ruido está activo, dibujarlo
    if (noise_burst_active) {
        noise_burst_timer--;
        
        // RUIDO INTENSO MASIVO
        repeat(300) {
            var _rx = irandom(_w);
            var _ry = irandom(_h);
            draw_set_alpha(random_range(0.3, 0.7));
            draw_set_color(make_color_rgb(
                irandom_range(150, 255),
                irandom_range(150, 255),
                irandom_range(150, 255)
            ));
            draw_circle(_rx, _ry, random_range(1, 3), false);
        }
        
        // Bloques de interferencia (como pixeles muertos)
        repeat(15) {
            var _bx = irandom(_w - 40);
            var _by = irandom(_h - 40);
            var _bw = irandom_range(20, 60);
            var _bh = irandom_range(3, 8);
            draw_set_alpha(random_range(0.4, 0.8));
            draw_set_color(make_color_rgb(
                irandom_range(100, 255),
                irandom_range(100, 255),
                irandom_range(100, 255)
            ));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
        }
        
        // Líneas horizontales de distorsión
        repeat(8) {
            var _ly = irandom(_h);
            var _loffset = irandom_range(-10, 10);
            draw_set_alpha(random_range(0.3, 0.6));
            draw_set_color(make_color_rgb(
                irandom_range(150, 255),
                irandom_range(150, 255),
                irandom_range(150, 255)
            ));
            draw_rectangle(_loffset, _ly, _w + _loffset, _ly + 2, false);
        }
        
        draw_set_alpha(1);
        
        // Desactivar cuando se acabe el tiempo
        if (noise_burst_timer <= 0) {
            noise_burst_active = false;
        }
    }
    
    // Línea de barrido vertical (rolling bar) - PERMANENTE
    var _scan_y = (current_time / 20) % _h;
    draw_set_alpha(0.2);
    draw_set_color(c_white);
    draw_rectangle(0, _scan_y, _w, _scan_y + 3, false);
    draw_set_alpha(1);
    
    // Distorsión ocasional (glitch horizontal)
    if (irandom(100) < 3) { // 3% de probabilidad cada frame
        var _glitch_y = irandom(_h);
        var _glitch_offset = irandom_range(-5, 5);
        draw_set_alpha(0.4);
        draw_set_color(make_color_rgb(
            irandom_range(0, 255),
            irandom_range(0, 255),
            irandom_range(0, 255)
        ));
        draw_rectangle(_glitch_offset, _glitch_y, _w + _glitch_offset, _glitch_y + 2, false);
        draw_set_alpha(1);
    }
    
    // Viñeta en los bordes (efecto de pantalla curva)
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _w, 40, false); // Superior
    draw_rectangle(0, _h - 40, _w, _h, false); // Inferior
    draw_rectangle(0, 0, 30, _h, false); // Izquierda
    draw_rectangle(_w - 30, 0, _w, _h, false); // Derecha
    draw_set_alpha(1);
    
    // ---------------------------------------------------------
    // 2. PANEL SUPERIOR - NOMBRE DE CÁMARA
    // ---------------------------------------------------------
    
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