/// @description Interacción y Control de Invisibilidad

if (instance_exists(obj_jugador)) {
    
    var _dist = distance_to_object(obj_jugador);
    
    // --- ESTOY CERCA ---
    if (_dist < interaction_radius) {
        
        mostrar_mensaje = true; 
        
        // DETECTAR TECLA E
        if (keyboard_check_pressed(ord("E"))) {
            
            // CASO A: CERRAR (CANCELAR) -> Volver a ser visible
            if (instance_exists(obj_vent_ui)) {
                instance_destroy(obj_vent_ui);
                obj_jugador.visible = true; 
                global.player_hidden = false; // ¡YA NO ESTOY ESCONDIDO!
            }
            
            // CASO B: ABRIR (ENTRAR) -> Volverse invisible
            else {
                instance_create_layer(0, 0, layer, obj_vent_ui);
                
                obj_jugador.visible = false; 
                global.current_vent_id = id; 
                global.player_hidden = true; // ¡ESTOY ESCONDIDO!
            }
        }
        
    } 
    // --- ME ALEJÉ ---
    else {
        mostrar_mensaje = false;
        
        // Seguridad: Cerrar si me alejo
        if (instance_exists(obj_vent_ui)) {
            if (global.current_vent_id == id) {
                 instance_destroy(obj_vent_ui);
                 obj_jugador.visible = true;
                 global.player_hidden = false; // Seguridad extra
            }
        }
    }
}