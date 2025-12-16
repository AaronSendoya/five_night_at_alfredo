/// @description Lógica de Entrar / Salir

if (instance_exists(obj_jugador)) {
    
    // ---------------------------------------------------
    // ESTADO 1: JUGADOR YA ESTÁ ESCONDIDO AQUÍ
    // ---------------------------------------------------
    if (escondido_aqui) {
        
        // Mantenemos al jugador invisible en el centro del objeto 
        // (Esto es bueno para que la cámara se centre en el escondite)
        obj_jugador.x = x + (sprite_width / 2); 
        obj_jugador.y = y + (sprite_height / 2);
        
        // INTERACCIÓN: SALIR (Tecla E)
        if (keyboard_check_pressed(ord("E"))) {
            
            // --- AQUÍ ESTÁ EL ARREGLO ---
            // Antes de soltarlo, lo devolvemos a donde estaba parado antes de entrar.
            // Como pudo entrar desde ahí, sabemos que es un lugar seguro sin paredes.
            obj_jugador.x = saved_x;
            obj_jugador.y = saved_y;
            
            escondido_aqui = false;
            
            // Reactivar jugador
            obj_jugador.visible = true;
            global.player_hidden = false; 
        }
    }
    
    // ---------------------------------------------------
    // ESTADO 2: JUGADOR ESTÁ FUERA (BUSCANDO ESCONDERSE)
    // ---------------------------------------------------
    else {
        var _dist = distance_to_object(obj_jugador);
        
        if (_dist < interaction_radius && !global.player_hidden) {
            
            mostrar_mensaje = true;
            
            // INTERACCIÓN: ENTRAR (Tecla E)
            if (keyboard_check_pressed(ord("E"))) {
                
                // --- AQUÍ GUARDAMOS LA POSICIÓN ---
                // Guardamos las coordenadas EXACTAS donde el jugador está parado ahora mismo.
                saved_x = obj_jugador.x;
                saved_y = obj_jugador.y;
                
                escondido_aqui = true;
                
                // Desactivar jugador
                obj_jugador.visible = false;
                global.player_hidden = true;
            }
            
        } else {
            mostrar_mensaje = false;
        }
    }
}