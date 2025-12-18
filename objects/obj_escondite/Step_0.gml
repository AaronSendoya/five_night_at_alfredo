/// @description Lógica de Entrar / Salir / Tiempo

if (instance_exists(obj_jugador)) {
    
    // A. GESTIÓN DEL COOLDOWN (Si no estoy escondido, el cooldown baja)
    if (!escondido_aqui && hide_cooldown > 0) {
        hide_cooldown--;
    }

    // ---------------------------------------------------
    // ESTADO 1: JUGADOR YA ESTÁ ESCONDIDO AQUÍ
    // ---------------------------------------------------
    if (escondido_aqui) {
        
        // 1. DRENAR TIEMPO (AIRE)
        if (hide_time_current > 0) {
            hide_time_current--;
        }

        // 2. MANTENER AL JUGADOR CENTRADO
        obj_jugador.x = x + (sprite_width / 2); 
        obj_jugador.y = y + (sprite_height / 2);
        
        // 3. DETECTAR SALIDA
        var _salir_manual  = keyboard_check_pressed(ord("E"));
        var _salir_forzado = (hide_time_current <= 0); // Se acabó el aire
        
        if (_salir_manual || _salir_forzado) {
            
            // Restaurar posición segura
            obj_jugador.x = saved_x;
            obj_jugador.y = saved_y;
            
            escondido_aqui = false;
            
            // Reactivar jugador
            obj_jugador.visible = true;
            global.player_hidden = false; 
            
            // --- LÓGICA DE CASTIGO ---
            if (_salir_forzado) {
                // Si se le acabó el aire, se agita y tiene que esperar
                hide_cooldown = hide_cooldown_max; 
                show_debug_message("¡Salida forzada! Cooldown activado.");
            } else {
                // Si salió voluntariamente, NO hay cooldown (o muy breve)
                hide_cooldown = 0; 
            }
        }
    }
    
    // ---------------------------------------------------
    // ESTADO 2: JUGADOR ESTÁ FUERA (BUSCANDO ESCONDERSE)
    // ---------------------------------------------------
    else {
        var _dist = distance_to_object(obj_jugador);
        
        // Mostrar mensaje si está cerca y NO está escondido en otro lado
        if (_dist < interaction_radius && !global.player_hidden) {
            mostrar_mensaje = true;
            
            // SOLO PERMITIR ENTRAR SI NO HAY COOLDOWN
            if (hide_cooldown <= 0) {
                if (keyboard_check_pressed(ord("E"))) {
                    // Guardar posición
                    saved_x = obj_jugador.x;
                    saved_y = obj_jugador.y;
                    
                    escondido_aqui = true;
                    
                    // RESETEAR EL TIEMPO DE AIRE AL ENTRAR
                    hide_time_current = hide_time_max;
                    
                    // Desactivar jugador
                    obj_jugador.visible = false;
                    global.player_hidden = true;
                }
            }
        } else {
            mostrar_mensaje = false;
        }
    }
}