/// @description Rayos Realistas y Fusibles

draw_self(); // Dibuja el panel base

// ---------------------------------------------------------
// 1. EFECTO DE ELECTRICIDAD "HIGH VOLTAGE"
// ---------------------------------------------------------
// Aumenté la probabilidad a 15% para que se vea más seguido
if (random(100) < 20) { 
    
    // --- MAGIA VISUAL: BLEND MODE ADD ---
    // Esto hace que los colores se sumen, creando un efecto de "Luz Brillante"
    gpu_set_blendmode(bm_add);
    
    // Configuración del rayo
    var _center_x = x;       // Centro horizontal
    var _center_y = y - 100; // Altura aproximada de los fusibles
    
    // Dibujamos 2 o 3 rayos a la vez para darle volumen
    repeat(choose(1, 2)) {
        
        var _segments = 5; // Cuántos quiebres tiene el rayo
        var _dist = irandom_range(40, 90); // Longitud del rayo
        var _angle = irandom(360); // Dirección aleatoria
        
        // Punto de inicio (cerca de los fusibles)
        var _xx = _center_x + lengthdir_x(random(20), _angle);
        var _yy = _center_y + lengthdir_y(random(20), _angle);
        
        // Colores
        var _col_glow = c_aqua;  // Resplandor exterior
        var _col_core = c_white; // Núcleo caliente
        
        // Bucle para dibujar los segmentos zig-zag
        for (var k = 0; k < _segments; k++) {
            // Calcular siguiente punto avanzando un poco
            var _step_len = _dist / _segments;
            var _next_x = _xx + lengthdir_x(_step_len, _angle);
            var _next_y = _yy + lengthdir_y(_step_len, _angle);
            
            // AÑADIR CAOS (El zig-zag)
            _next_x += irandom_range(-15, 15);
            _next_y += irandom_range(-15, 15);
            
            // 1. DIBUJAR RESPLANDOR (Grueso y Azul)
            draw_set_alpha(0.6);
            draw_set_color(_col_glow);
            draw_line_width(_xx, _yy, _next_x, _next_y, 5);
            
            // 2. DIBUJAR NÚCLEO (Fino y Blanco)
            draw_set_alpha(1);
            draw_set_color(_col_core);
            draw_line_width(_xx, _yy, _next_x, _next_y, 2);
            
            // Avanzar al siguiente segmento
            _xx = _next_x;
            _yy = _next_y;
        }
    }
    
    // IMPORTANTE: Resetear el modo de fusión a normal
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// 2. DIBUJAR FUSIBLES (Tu código calibrado)
// ---------------------------------------------------------
for (var i = 0; i < 4; i++) {
    if (fusibles[i] == 1) {
        var _draw_x = x + fuse_start_x + (i * fuse_sep);
        var _draw_y = y + fuse_offset_y;
        draw_sprite(sp_fusible_1, 0, _draw_x, _draw_y);
    }
}

// ---------------------------------------------------------
// 3. TEXTO FLOTANTE (Solo si no estamos reparando)
// ---------------------------------------------------------
if (mostrar_mensaje && !is_repairing) {
    draw_set_halign(fa_center);
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small);
    
    if (contar_activos() < 4) {
        draw_set_color(c_yellow);
        draw_text(x, y - 220, "MANTÉN [E] PARA REPARAR"); 
    } else {
        draw_set_color(c_lime);
        draw_text(x, y - 220, "SISTEMA ESTABLE");
    }
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}