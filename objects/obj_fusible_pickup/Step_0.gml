/// @description Detectar Jugador y Recoger

if (instance_exists(obj_jugador)) {
    var _dist = distance_to_object(obj_jugador);
    
    if (_dist < interaction_radius) {
        mostrar_mensaje = true;
        
        if (keyboard_check_pressed(ord("E"))) {
            
            // --- NUEVA LÓGICA: HABLAR CON INVENTARIO ---
            if (instance_exists(obj_inventario)) {
                
                // Intentar añadir 1 fusible ("fusible" es la clave en item_db)
                var _exito = obj_inventario.add_item("fusible", 1);
                
                if (_exito) {
                    // Sonido de éxito
                    // audio_play_sound(snd_pickup, 10, false);
                    instance_destroy(); // Desaparece del suelo
                } else {
                    // Inventario lleno
                    // audio_play_sound(snd_error, 10, false);
                    mostrar_mensaje_lleno = true; // Variable para mostrar texto rojo temporalmente
                }
            }
        }
    } else {
        mostrar_mensaje = false;
    }
}
// ... (resto de tu código de flotación) ...

// Animación suave de flotación (solo visual)
float_angle += 0.05;
float_y = sin(float_angle) * 2;

