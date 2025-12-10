/// @description Lógica del Fade

if (estado == "saliendo") {
    // 1. Oscurecer la pantalla poco a poco
    alpha += velocidad_efecto;
    
    // 2. Cuando sea totalmente negro... ¡CAMBIAMOS DE SALA!
    if (alpha >= 1) {
        room_goto(target_room);
        
        // Movemos al jugador mientras nadie ve
        obj_jugador.x = target_x;
        obj_jugador.y = target_y;
        
        // Le cambiamos la ropa (sprite) para que mire al frente o donde digas
        if (target_sprite != -1) {
            obj_jugador.sprite_index = target_sprite;
        }
        
        // Cambiar estado para empezar a aclarar
        estado = "entrando";
    }
} 
else if (estado == "entrando") {
    // 3. Aclarar la pantalla poco a poco
    alpha -= velocidad_efecto;
    
    // 4. Si ya es invisible, destruimos este objeto de transición
    if (alpha <= 0) {
        instance_destroy();
    }
}