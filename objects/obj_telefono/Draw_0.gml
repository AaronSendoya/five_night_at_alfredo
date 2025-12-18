/// @description Dibujar teléfono con efectos

// Dibujar el teléfono
if (esta_sonando) {
    // Parpadeo de color cuando suena (sincronizado con el shake)
    var _flash = abs(sin(current_time / 150)); // Oscila 0-1 rápido
    
    // Mezcla entre color normal y amarillo
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        1, 
        1, 
        0, 
        merge_color(c_white, c_yellow, _flash), 
        1
    );
} else {
    // Normal
    draw_self();
}

// Si el jugador puede interactuar, mostrar tecla E
if (puede_interactuar && esta_sonando) {
    var _e_x = x;
    var _e_y = y - 50; // Un poco más arriba
    
    // Efecto de flotación
    var _float = sin(current_time / 200) * 3;
    
    // Verificar que el sprite existe
    if (sprite_exists(sp_tecla_e)) {
        // Usar draw_sprite_ext para escalar
        draw_sprite_ext(
            sp_tecla_e, 
            0, 
            _e_x, 
            _e_y + _float, 
            4,      // Escala X (2 = doble de tamaño)
            4,      // Escala Y (2 = doble de tamaño)
            0,      // Rotación
            c_white, 
            1       // Alpha
        );
    }
}