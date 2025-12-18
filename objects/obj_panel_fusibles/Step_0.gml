/// @description Reparar (Lógica corregida)

if (instance_exists(obj_jugador)) {
    var _dist = distance_to_object(obj_jugador);
    
    // Si estamos cerca
    if (_dist < interaction_radius) {
        
        // 1. ¿El panel necesita reparación? (Hay huecos vacíos)
        var _needs_repair = (contar_activos() < 4);
        
        if (_needs_repair) {
            
            // ---------------------------------------------------------
            // 2. VERIFICACIÓN DE INVENTARIO (CORRECCIÓN)
            // ---------------------------------------------------------
            // Revisamos si REALMENTE tenemos un fusible antes de mostrar nada
            var _tiene_fusible = false;
            
            if (instance_exists(obj_inventario)) {
                // Recorremos los slots del inventario buscando la ID "fusible"
                for (var k = 0; k < obj_inventario.total_slots; k++) {
                    var _slot = obj_inventario.inventory[k];
                    
                    // Si el slot no está vacío Y el item es "fusible"
                    if (_slot != noone && _slot.id == "fusible") {
                        _tiene_fusible = true;
                        break; // Ya encontramos uno, no hace falta seguir buscando
                    }
                }
            }
            
            // ---------------------------------------------------------
            // 3. LÓGICA DE MANTENER 'E'
            // ---------------------------------------------------------
            // Solo entra aquí si presionas E **Y** tienes el fusible
            if (keyboard_check(ord("E")) && _tiene_fusible) {
                
                is_repairing = true; // Activa la barra circular
                mostrar_mensaje = false; // Oculta el texto "Mantén E"
                
                repair_timer++; // Aumentar tiempo
                
                // Si completó los 3 segundos (180 frames)
                if (repair_timer >= repair_time_max) {
                    
                    // --- ACCIÓN FINAL: REPARAR ---
                    // Consumimos el item (ahora sabemos seguro que lo tiene)
                    if (obj_inventario.consume_item("fusible", 1)) {
                        
                        // Buscar slot vacío en el panel y llenarlo
                        for (var i = 0; i < 4; i++) {
                            if (fusibles[i] == 0) {
                                fusibles[i] = 1;
                                break; 
                            }
                        }
                        
                        // Sonido de éxito (opcional)
                        // audio_play_sound(snd_repair_complete, 10, false);
                        show_debug_message("¡Reparación completada!");
                    }
                    
                    // Resetear todo al terminar
                    repair_timer = 0;
                    is_repairing = false;
                }
            } 
            // Si sueltas la tecla O no tienes fusible
            else {
                repair_timer = 0;
                is_repairing = false; // Esto borra la barra circular
                mostrar_mensaje = true; // Vuelve a mostrar el texto flotante
            }
            
        } else {
            // El panel está lleno (Sistema Estable)
            mostrar_mensaje = true;
            is_repairing = false;
            repair_timer = 0;
        }
        
    } else {
        // Lejos del panel
        mostrar_mensaje = false;
        is_repairing = false;
        repair_timer = 0;
    }
	// =========================================================
	// GESTIÓN DE TIEMPOS (Corrección del mensaje)
	// =========================================================

	// Si el temporizador es mayor a 0, le restamos 1 en cada frame.
	if (warning_timer > 0) {
	    warning_timer--; 
	}
}