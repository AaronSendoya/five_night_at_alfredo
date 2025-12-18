/// @description Lógica de Interacción + Seguridad Eléctrica

// Si estamos cerca
if (distance_to_object(obj_jugador) < 160) {
    
    mostrar_mensaje = true; 
    
    // Permitir pulsar E
    if (keyboard_check_pressed(ord("E"))) {
        
        // --- NUEVA LÓGICA: VERIFICAR ELECTRICIDAD ---
        if (global.power_on == false) {
            // Si no hay luz, reproducir sonido de error y NO abrir
            // audio_play_sound(snd_error_buzz, 50, false);
            show_debug_message("ERROR: SIN ENERGÍA");
            
            // Opcional: Mostrar texto flotante "SYSTEM FAILURE"
        } 
        else {
            // Si HAY luz, funcionamos normal
            audio_play_sound(snd_open_camera, 50, false);
            global.en_camaras = !global.en_camaras; 
        }
    }
    
} else {
    // Si nos alejamos
    mostrar_mensaje = false; 
    
    // Si te alejas mucho, apagar cámaras automáticamente
    if (global.en_camaras) global.en_camaras = false; 
}