if (global.en_camaras) {
    
    // Obtener dimensiones PRIMERO (necesarias para todo)
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    // -------------------------------
    // NUEVO: bandera de cámara rota
    // -------------------------------
    var _cam_rota = (camara_actual == 6);
    
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
    
    
    // ---------------------------------------------------------
    // NUEVO: CAM 07 ROTA -> SIEMPRE NEGRO (ignora application_surface)
    // ---------------------------------------------------------
    if (_cam_rota) {
        draw_set_color(c_black);
        draw_rectangle(0, 0, _w, _h, false);
        draw_set_color(c_white);
    }
    else if (interferencia == true) {
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
    
    // ---------------------------------------------------------
    // NUEVO: EFECTO CONSTANTE DE "PANTALLA ROTA" SOLO EN CAM 07
    // (más agresivo que la interferencia normal)
    // ---------------------------------------------------------
    if (_cam_rota) {
        // Ruido constante fuerte
        repeat(220) {
            var _rx2 = irandom(_w);
            var _ry2 = irandom(_h);
            draw_set_alpha(random_range(0.25, 0.55));
            var _g = irandom_range(160, 255);
            draw_set_color(make_color_rgb(_g, _g, _g));
            draw_circle(_rx2, _ry2, random_range(1, 2.5), false);
        }
        draw_set_alpha(1);

        // Bandas de glitch fijas/erráticas
        repeat(18) {
            var _gy = irandom(_h);
            var _gh = irandom_range(2, 6);
            var _off = irandom_range(-20, 20);
            draw_set_alpha(random_range(0.35, 0.75));
            var _c = irandom_range(120, 255);
            draw_set_color(make_color_rgb(_c, _c, _c));
            draw_rectangle(_off, _gy, _w + _off, _gy + _gh, false);
        }
        draw_set_alpha(1);

        // “Bloques corruptos”
        repeat(20) {
            var _bx2 = irandom(_w - 80);
            var _by2 = irandom(_h - 80);
            var _bw2 = irandom_range(30, 120);
            var _bh2 = irandom_range(6, 22);
            draw_set_alpha(random_range(0.25, 0.6));
            var _cc2 = irandom_range(80, 200);
            draw_set_color(make_color_rgb(_cc2, _cc2, _cc2));
            draw_rectangle(_bx2, _by2, _bx2 + _bw2, _by2 + _bh2, false);
        }
        draw_set_alpha(1);

        // Grietas (simulación de vidrio roto)
        var _cx = _w * 0.55 + irandom_range(-8, 8);
        var _cy = _h * 0.45 + irandom_range(-8, 8);
        draw_set_alpha(0.35);
        draw_set_color(make_color_rgb(210, 210, 210));

        // Rayos principales
        for (var r = 0; r < 10; r++) {
            var ang = r * 36 + irandom_range(-10, 10);
            var len = irandom_range(220, 520);
            var x2 = _cx + lengthdir_x(len, ang);
            var y2 = _cy + lengthdir_y(len, ang);
            draw_line_width(_cx, _cy, x2, y2, 2);

            // ramificaciones
            var bx = _cx + lengthdir_x(len * 0.55, ang);
            var by = _cy + lengthdir_y(len * 0.55, ang);
            var ang2 = ang + irandom_range(-35, 35);
            var len2 = irandom_range(80, 180);
            draw_line_width(bx, by, bx + lengthdir_x(len2, ang2), by + lengthdir_y(len2, ang2), 1);
        }
        draw_set_alpha(1);
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
        case 6: _nombre_sala = "CAM 07: ???"; break;
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
    var _cx2 = _w / 2;
    var _cy2 = _h - 35;
    
    // Sombra
    draw_set_color(c_black);
    draw_text(_cx2 + 2, _cy2 + 2, _txt_inst);
    
    // Texto principal
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text(_cx2, _cy2, _txt_inst);
    
    // ---------------------------------------------------------
    // 5. EFECTO DE TRANSICIÓN ENTRE CÁMARAS (OPCIONAL)
    // ---------------------------------------------------------
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

	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_font(fnt_pixel_small);

	var _timestamp = string(current_hour) + ":" + 
	                 string_format(current_minute, 2, 0) + ":" +
	                 string_format(floor(current_second), 2, 0);

	// Sombra del timestamp
	draw_set_color(c_black);
	draw_text(22, _h - 12, _timestamp);

	// Texto principal del timestamp
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
	// PANTALLA ROTA MEJORADA (solo CAM 07)
	// ---------------------------------------------------------
	if (_cam_rota) {
    
	    // =======================================================
	    // 1. EFECTO DE ESTÁTICA ESTRATIFICADA (Múltiples Capas)
	    // =======================================================
    
	    // Capa 1: Ruido fino de fondo
	    repeat(250) {
	        var _rx = irandom(_w);
	        var _ry = irandom(_h);
	        draw_set_alpha(random_range(0.08, 0.2));
	        var _brightness = irandom_range(120, 180);
	        draw_set_color(make_color_rgb(_brightness, _brightness, _brightness));
	        draw_circle(_rx, _ry, 1, false);
	    }
    
	    // Capa 2: Ruido medio (puntos más grandes)
	    repeat(120) {
	        var _rx = irandom(_w);
	        var _ry = irandom(_h);
	        draw_set_alpha(random_range(0.15, 0.4));
	        var _brightness = irandom_range(150, 220);
	        draw_set_color(make_color_rgb(_brightness, _brightness, _brightness));
	        draw_circle(_rx, _ry, random_range(1.5, 2.5), false);
	    }
    
	    // Capa 3: Ruido intenso (manchas)
	    repeat(40) {
	        var _rx = irandom(_w);
	        var _ry = irandom(_h);
	        draw_set_alpha(random_range(0.25, 0.6));
	        var _brightness = irandom_range(180, 255);
	        draw_set_color(make_color_rgb(_brightness, _brightness, _brightness));
	        draw_circle(_rx, _ry, random_range(2, 4), false);
	    }
    
	    draw_set_alpha(1);
    
	    // =======================================================
	    // 2. BANDAS HORIZONTALES DE INTERFERENCIA
	    // =======================================================
	    repeat(8) {
	        var _band_y = irandom(_h);
	        var _band_height = irandom_range(2, 6);
	        var _band_offset = irandom_range(-8, 8);
        
	        draw_set_alpha(random_range(0.2, 0.5));
	        var _band_bright = irandom_range(100, 200);
	        draw_set_color(make_color_rgb(_band_bright, _band_bright, _band_bright));
	        draw_rectangle(_band_offset, _band_y, _w + _band_offset, _band_y + _band_height, false);
	    }
	    draw_set_alpha(1);
    
	    // =======================================================
	    // 3. BLOQUES DE CORRUPCIÓN (Pixeles Muertos)
	    // =======================================================
	    repeat(12) {
	        var _block_x = irandom(_w - 60);
	        var _block_y = irandom(_h - 40);
	        var _block_w = irandom_range(30, 80);
	        var _block_h = irandom_range(4, 12);
        
	        draw_set_alpha(random_range(0.3, 0.7));
	        var _block_color = irandom_range(60, 160);
	        draw_set_color(make_color_rgb(_block_color, _block_color, _block_color));
	        draw_rectangle(_block_x, _block_y, _block_x + _block_w, _block_y + _block_h, false);
	    }
	    draw_set_alpha(1);
    
	    // =======================================================
	    // 4. LÍNEA DE BARRIDO VERTICAL ROTA (Movimiento Errático)
	    // =======================================================
	    var _scan_y = (current_time / 15) % _h;
	    var _scan_distortion = sin(current_time / 100) * 3;
    
	    draw_set_alpha(0.4);
	    draw_set_color(make_color_rgb(220, 220, 220));
	    draw_rectangle(_scan_distortion, _scan_y, _w + _scan_distortion, _scan_y + 4, false);
	    draw_set_alpha(1);
    
	    // =======================================================
	    // 5. PANEL DE ERROR PROFESIONAL
	    // =======================================================
	    var _panel_w = 520;
	    var _panel_h = 150;
	    var _panel_x = (_w / 2) - (_panel_w / 2);
	    var _panel_y = (_h / 2) - (_panel_h / 2);
    
	    // Sombra del panel (profundidad)
	    draw_set_alpha(0.6);
	    draw_set_color(c_black);
	    draw_rectangle(_panel_x + 4, _panel_y + 4, _panel_x + _panel_w + 4, _panel_y + _panel_h + 4, false);
    
	    // Fondo del panel
	    draw_set_alpha(0.94);
	    draw_set_color(c_black);
	    draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
	    draw_set_alpha(1);
    
	    // Triple borde (efecto de profundidad)
	    draw_set_color(make_color_rgb(100, 30, 30));
	    draw_rectangle(_panel_x - 2, _panel_y - 2, _panel_x + _panel_w + 2, _panel_y + _panel_h + 2, true);
    
	    draw_set_color(make_color_rgb(160, 50, 50));
	    draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, true);
    
	    draw_set_color(make_color_rgb(200, 70, 70));
	    draw_rectangle(_panel_x + 2, _panel_y + 2, _panel_x + _panel_w - 2, _panel_y + _panel_h - 2, true);
    
	    // =======================================================
	    // 6. ICONO DE ADVERTENCIA (Triángulo + Glow)
	    // =======================================================
	    var _icon_size = 24;
	    var _icon_x = _w / 2;
	    var _icon_y = _panel_y + 50;
    
	    // Glow detrás del triángulo
	    draw_set_alpha(0.3);
	    draw_set_color(make_color_rgb(220, 80, 80));
	    draw_circle(_icon_x, _icon_y, _icon_size + 6, false);
	    draw_set_alpha(1);
    
	    // Triángulo de advertencia
	    draw_set_color(make_color_rgb(220, 80, 80));
	    draw_triangle(
	        _icon_x, _icon_y - _icon_size,
	        _icon_x - _icon_size, _icon_y + _icon_size,
	        _icon_x + _icon_size, _icon_y + _icon_size,
	        false
	    );
    
	    // Borde del triángulo
	    draw_set_color(make_color_rgb(140, 40, 40));
	    draw_triangle(
	        _icon_x, _icon_y - _icon_size,
	        _icon_x - _icon_size, _icon_y + _icon_size,
	        _icon_x + _icon_size, _icon_y + _icon_size,
	        true
	    );
    
	    // Signo de exclamación
	    draw_set_font(fnt_camara_osd);
	    draw_set_halign(fa_center);
	    draw_set_valign(fa_middle);
	    draw_set_color(c_black);
	    draw_text(_icon_x, _icon_y + 4, "!");
    
	    // =======================================================
	    // 7. TEXTO "SIN SEÑAL" (Mejorado con Glow)
	    // =======================================================
	    var _text_y = _panel_y + 95;
    
	    // Glow rojo detrás del texto
	    draw_set_alpha(0.4);
	    draw_set_color(make_color_rgb(240, 100, 100));
	    draw_text((_w / 2) - 1, _text_y, "SIN SENAL");
	    draw_text((_w / 2) + 1, _text_y, "SIN SENAL");
	    draw_text(_w / 2, _text_y - 1, "SIN SENAL");
	    draw_text(_w / 2, _text_y + 1, "SIN SENAL");
	    draw_set_alpha(1);
    
	    // Sombra
	    draw_set_color(c_black);
	    draw_text((_w / 2) + 2, _text_y + 2, "SIN SENAL");
    
	    // Texto principal
	    draw_set_color(make_color_rgb(255, 120, 120));
	    draw_text(_w / 2, _text_y, "SIN SENAL");
    
	    // =======================================================
	    // 8. SUBTEXTO EXPLICATIVO
	    // =======================================================
	    draw_set_font(fnt_pixel_small);
	    draw_set_color(make_color_rgb(100, 100, 100));
	    draw_text(_w / 2, _panel_y + 125, "CAMARA FUERA DE SERVICIO");
    
	    // Línea decorativa debajo del subtexto
	    draw_set_color(make_color_rgb(80, 30, 30));
	    draw_line_width(_panel_x + 100, _panel_y + 135, _panel_x + _panel_w - 100, _panel_y + 135, 1);
    
	    // =======================================================
	    // 9. RESETEAR TODO
	    // =======================================================
	    draw_set_alpha(1);
	    draw_set_color(c_white);
	    draw_set_halign(fa_left);
	    draw_set_valign(fa_top);
	    draw_set_font(-1);
	}
    
    // ---------------------------------------------------------
    // RESTAURAR VALORES POR DEFECTO
    // ---------------------------------------------------------
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1); 
    draw_set_color(c_white);
}
