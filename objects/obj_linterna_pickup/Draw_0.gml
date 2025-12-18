/// @description Efectos Visuales Limpios

// 1. DIBUJAR LA LINTERNA EN EL SUELO
draw_self();

// Solo dibujamos efectos si el jugador está cerca
if (mostrar_mensaje) {
    
    // --- CÁLCULOS DE ANIMACIÓN ---
    flotar_angulo += 0.08;
    var _flotar_y = sin(flotar_angulo) * 5; 
    
    // POSICIÓN Y: 
    // Ajustado para que flote encima del objeto sin taparlo
    var _key_y = y - 65 + _flotar_y; 
    
    // ESCALA: 
    // Mantenemos el tamaño grande (3.5)
    var _base_scale = 3.5; 
    var _scale_pulse = _base_scale + (sin(flotar_angulo * 2) * 0.1); 
    
    // --- A. RESPLANDOR ALREDEDOR DEL OBJETO (LINTERNA) ---
    var _glow_alpha = 0.5 + (sin(current_time / 200) * 0.3);
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 1.1, image_yscale * 1.1, image_angle, c_yellow, _glow_alpha * 0.5);
    gpu_set_blendmode(bm_normal);
    
    // --- B. DIBUJAR LA TECLA 'E' FLOTANTE (SIN CÍRCULO) ---
    
    if (sprite_exists(asset_get_index("sp_tecla_e"))) {
        
        // Sombra negra pegada (para contraste sin círculo)
        draw_sprite_ext(sp_tecla_e, 0, x + 3, _key_y + 3, _scale_pulse, _scale_pulse, 0, c_black, 0.6);
        
        // Tecla Blanca Principal
        // IMPORTANTE: Se dibuja en 'x' exacto. Si se ve descentrada, revisa el Origen del sprite.
        draw_sprite_ext(sp_tecla_e, 0, x, _key_y, _scale_pulse, _scale_pulse, 0, c_white, 1);
        
    } 
    else {
        // BACKUP DE TEXTO
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(x, _key_y, "[E]", 2, 2, 0); 
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // --- C. PARTÍCULAS (Opcional, si te molestan bórralas) ---
    draw_set_color(c_yellow);
    repeat(2) {
        var _px = x + irandom_range(-15, 15);
        var _py = y + irandom_range(-15, 15) - 25; // Un poco más abajo
        draw_set_alpha(random_range(0.3, 0.8));
        draw_circle(_px, _py, 2, false); 
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}