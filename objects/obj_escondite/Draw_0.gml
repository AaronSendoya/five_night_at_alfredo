///// @description Dibujar Objeto + Tecla E Flotante con Efectos

//// 1. DIBUJAR EL OBJETO REAL (Mesa, Armario, etc.)
//draw_self();

//// 2. EFECTO DE RESALTADO CUANDO ESTÁS CERCA
//if (mostrar_mensaje && !escondido_aqui) {
    
//    // Pulso sutil en el borde del objeto
//    var _pulse = (sin(current_time / 300) * 0.3) + 0.5; // Oscila entre 0.2 y 0.8
    
//    draw_set_alpha(_pulse * 0.25);
//    draw_set_color(c_white);
    
//    // Dibuja un contorno brillante alrededor del sprite
//    for (var i = 0; i < 360; i += 45) {
//        var _offset_x = lengthdir_x(3, i);
//        var _offset_y = lengthdir_y(3, i);
//        draw_sprite_ext(
//            sprite_index, image_index,
//            x + _offset_x, y + _offset_y,
//            image_xscale, image_yscale,
//            image_angle, c_white, _pulse * 0.15
//        );
//    }
//    draw_set_alpha(1);
//}

//// 3. DIBUJAR LA TECLA FLOTANTE 'sp_tecla_e' CON EFECTOS
//if (mostrar_mensaje && !escondido_aqui) {
    
//    // Animación de flotar más suave
//    flotar_angulo += 0.08;
//    var _flotar_y = sin(flotar_angulo) * 5;
    
//    // Coordenadas centradas
//    var _draw_x = x + (sprite_width / 2);
//    var _draw_y = y - 50 + _flotar_y;
    
//    // Pulso de escala
//    var _scale_pulse = 6 + (sin(flotar_angulo * 2) * 0.3);
    
//    // Glow detrás de la tecla (círculo suave)
//    var _glow_alpha = (sin(flotar_angulo * 2) * 0.3) + 0.4;
//    draw_set_alpha(_glow_alpha);
//    draw_set_color(c_white);
//    draw_circle(_draw_x, _draw_y, 24, false);
//    draw_set_alpha(1);
    
//    // Sombra de la tecla
//    draw_sprite_ext(
//        sp_tecla_e, 0,
//        _draw_x + 2, _draw_y + 2,
//        _scale_pulse, _scale_pulse,
//        0, c_black, 0.4
//    );
    
//    // Tecla principal
//    draw_sprite_ext(
//        sp_tecla_e, 0,
//        _draw_x, _draw_y,
//        _scale_pulse, _scale_pulse,
//        0, c_white, 1
//    );
    
//    // Partículas sutiles alrededor de la tecla
//    repeat(3) {
//        var _particle_angle = (current_time / 30 + random(360)) % 360;
//        var _particle_dist = 20 + sin(current_time / 100) * 5;
//        var _px = _draw_x + lengthdir_x(_particle_dist, _particle_angle);
//        var _py = _draw_y + lengthdir_y(_particle_dist, _particle_angle);
        
//        draw_set_alpha(random_range(0.2, 0.5));
//        draw_set_color(c_white);
//        draw_circle(_px, _py, random_range(1, 2), false);
//    }
//    draw_set_alpha(1);
//}