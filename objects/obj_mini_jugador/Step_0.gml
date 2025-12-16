/// @description Movimiento y Animación

// 1. Detectar dirección (-1 izquierda, 0 quieto, 1 derecha)
var _move = keyboard_check(vk_right) - keyboard_check(vk_left);

// 2. Lógica de Movimiento y Sprites
if (_move != 0) {
    // --- SI SE ESTÁ MOVIENDO ---
    
    // Moverse (velocidad 5)
    x += _move * 5;
    
    // Activar animación
    image_speed = 1; 
    
    // Cambiar sprite según dirección
    if (_move > 0) {
        sprite_index = sp_shadow_caminar_derecha; // Mirar derecha
    } else {
        sprite_index = sp_shadow_caminar_izquierda; // Mirar izquierda
    }
    
} else {
    // --- SI ESTÁ QUIETO ---
    
    // Parar animación y resetear al primer frame
    image_speed = 0;
    image_index = 0;
    
    // Opcional: Que mire al frente cuando se detiene
    sprite_index = sp_shadow_caminar_frente; 
}

// 3. Mantener dentro de la pantalla (Clamp)
// Usamos sprite_width/2 para que no se salga ni medio cuerpo
x = clamp(x, sprite_width/2, room_width - sprite_width/2);