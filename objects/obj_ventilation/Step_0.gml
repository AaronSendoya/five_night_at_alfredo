/// @description Interacción, Tiempo y Cooldown

if (instance_exists(obj_jugador)) {
    
    // =========================================================
    // 1. GESTIÓN DEL COOLDOWN
    // =========================================================
    if (!instance_exists(obj_vent_ui) && hide_cooldown > 0) {
        hide_cooldown--;
    }
    
    // Distancia al jugador
    var _dist = distance_to_object(obj_jugador);
    
    // =========================================================
    // 2. ESTOY CERCA (Lógica de Interacción)
    // =========================================================
    if (_dist < interaction_radius) {
        
        mostrar_mensaje = true; 
        
        // --- A. SI ESTOY DENTRO (UI ABIERTA - SALIDA INSTANTÁNEA) ---
        if (instance_exists(obj_vent_ui) && global.current_vent_id == id) {
            
            // Al estar dentro, reseteamos el timer de entrada para la próxima
            entry_timer = 0;

            // 1. RESTAR AIRE
            if (hide_time_current > 0) hide_time_current--;
            
            // 2. CHECK DE SALIDA
            var _salir_manual  = keyboard_check_pressed(ord("E"));
            var _salir_forzado = (hide_time_current <= 0);
            
            if (_salir_manual || _salir_forzado) {
                
                instance_destroy(obj_vent_ui);
                obj_jugador.visible = true; 
                global.player_hidden = false;
                
                if (_salir_forzado) {
                    hide_cooldown = hide_cooldown_max; 
                    show_debug_message("¡Expulsado! Cooldown activo.");
                } else {
                    hide_cooldown = 0; 
                }
            }
        }
        
        // --- B. SI ESTOY FUERA (UI CERRADA - ENTRADA CON DELAY) ---
        else {
            
            // SOLO permitir intentar si NO hay cooldown
            if (hide_cooldown <= 0) {
                
                // CAMBIO IMPORTANTE: Usamos 'keyboard_check' (Mantener) en lugar de 'pressed'
                if (keyboard_check(ord("E"))) {
                    
                    // Aumentamos el timer
                    entry_timer++;
                    
                    // Si completamos el segundo (60 frames)
                    if (entry_timer >= entry_max) {
                        
                        // --- ACCIÓN DE ENTRAR ---
                        instance_create_layer(0, 0, layer, obj_vent_ui);
                        
                        obj_jugador.visible = false; 
                        global.current_vent_id = id; 
                        global.player_hidden = true;
                        
                        // Reiniciar valores
                        hide_time_current = hide_time_max;
                        entry_timer = 0; 
                    }
                } 
                else {
                    // Si suelta la tecla, el progreso se pierde
                    entry_timer = 0;
                }
            }
        }
    } 
    
    // =========================================================
    // 3. ME ALEJÉ
    // =========================================================
    else {
        mostrar_mensaje = false;
        entry_timer = 0; // Resetear si me alejo
        
        // Seguridad por si me alejo con la UI abierta
        if (instance_exists(obj_vent_ui)) {
            if (global.current_vent_id == id) {
                 instance_destroy(obj_vent_ui);
                 obj_jugador.visible = true;
                 global.player_hidden = false;
            }
        }
    }
}