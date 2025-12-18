/// @description Interactuar (Toggle)

if (instance_exists(obj_jugador)) {
    if (distance_to_object(obj_jugador) < interaction_radius) {
        mostrar_mensaje = true;
        
        if (keyboard_check_pressed(ord("E"))) {
            is_on = !is_on; // Invertir valor
            
            // Sonido de Click
            // audio_play_sound(snd_switch, 10, false);
            
            // Actualizar visual
            image_index = (is_on) ? 1 : 0;
        }
    } else {
        mostrar_mensaje = false;
    }
}