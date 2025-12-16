/// @description Dibujar Rejilla + Tecla E Flotante

draw_self();

// Dibujar tecla flotante (Solo si no tengo el mapa abierto)
if (mostrar_mensaje && !instance_exists(obj_vent_ui)) {
    
    flotar_angulo += 0.1; 
    var _flotar_y = sin(flotar_angulo) * 5; 
    
    // Asegúrate de tener el sprite 'sp_tecla_e'
    draw_sprite_ext(
        sp_tecla_e, 0, 
        x + (sprite_width / 2), 
        y - 50 + _flotar_y,     // Posición (Arriba)
        4, 4,                   // ESCALA GRANDE (4x)
        0, c_white, 1
    );
}

/// @description Dibujar Rejilla + DEBUG DE SALIDA

draw_self();

// ... (Tu código de la tecla E flotante va aquí) ...

// --- DEBUG VISUAL (BORRAR AL FINALIZAR EL JUEGO) ---
if (global.debug_mode) { // O simplemente if (true) para probar ahora
    draw_set_color(c_red);
    
    // Calcular dónde caerá el jugador
    var _dest_x = x + lengthdir_x(exit_distance, exit_angle);
    var _dest_y = y + lengthdir_y(exit_distance, exit_angle);
    
    // Dibujar una línea desde el centro hasta el destino
    draw_line_width(x, y, _dest_x, _dest_y, 3);
    
    // Dibujar un círculo donde aparecerá el jugador
    draw_circle(_dest_x, _dest_y, 5, false);
    
    draw_set_color(c_white);
}