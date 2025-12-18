/// @description Detectar Jugador y Recoger

if (instance_exists(obj_jugador)) {
    
    // Calcular distancia
    var _dist = distance_to_object(obj_jugador);
    
    // Si estamos cerca...
    if (_dist < interaction_radius) {
        mostrar_mensaje = true;
        
        // INTERACCIÓN (Presionar E)
        if (keyboard_check_pressed(ord("E"))) {
            
            // 1. Activar la linterna real en el sistema
            if (instance_exists(obj_linterna)) {
                obj_linterna.has_flashlight = true;
                obj_linterna.battery_level = obj_linterna.battery_max; // Carga completa
                
                // Sonido (opcional)
                // audio_play_sound(snd_pickup_item, 10, false);
            }
            
            // 2. Destruir este objeto del suelo
            instance_destroy();
        }
    } 
    else {
        // Si nos alejamos, ocultamos el mensaje
        mostrar_mensaje = false;
    }
}