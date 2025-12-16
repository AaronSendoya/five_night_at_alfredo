/// @description IA Foxy: Luz vs Oscuridad

// 0. SEGURIDAD
if (my_ai_level == 0) exit;

// =================================================================
// CASO A: HAY LUZ (RETIRADA ESTRATÉGICA)
// =================================================================
if (global.power_on == true) {
    
    // Asegurar visibilidad
    visible = true;

    // IMPORTANTE: NO llamamos a event_inherited() aquí.
    // Nosotros controlamos el movimiento manual a casa.
    
    // 1. ¿Estamos lejos de casa? (Margen de 16px)
    if (point_distance(x, y, home_x, home_y) > 16) {
        
        // Si no estamos moviéndonos ya en el path de retorno...
        if (path_index != path_return) {
            // Calcular ruta a casa
            if (mp_grid_path(grid_ia, path_return, x, y, home_x, home_y, true)) {
                // Ir a casa rápido para esconderse
                path_start(path_return, velocidad_caza, path_action_stop, true);
                show_debug_message("FOXY: ¡Luz! Regresando a la cueva.");
            }
        }
        
        // ANIMACIÓN MANUAL DE RETORNO (Porque anulamos al padre)
        image_speed = 1;
        var _dir = direction;
        // Normalizar dirección para que no de negativo
        if (_dir < 0) _dir += 360;
        if (_dir >= 360) _dir -= 360;

        if (_dir > 45 && _dir <= 135) sprite_index = spr_atras;
        else if (_dir > 135 && _dir <= 225) sprite_index = spr_izquierda;
        else if (_dir > 225 && _dir <= 315) sprite_index = spr_frente;
        else sprite_index = spr_derecha;
        
    } 
    else {
        // 2. YA LLEGAMOS A CASA (IDLE)
        if (path_index != -1) path_end(); // Detener si seguía en path
        
        speed = 0;
        x = home_x; // Asegurar posición exacta
        y = home_y;
        
        // Sprite de reposo (Mirando al frente)
        sprite_index = spr_frente; 
        image_speed = 0;
        image_index = 0;
    }
} 

// =================================================================
// CASO B: NO HAY LUZ (MODO CAZA)
// =================================================================
else {
    // Asegurar visibilidad
    visible = true;

    // Restaurar velocidades de ataque
    move_speed  = velocidad_normal;
    chase_speed = velocidad_caza;
    
    // Si estábamos regresando a casa, cancelar ese camino inmediatamente
    // para que el padre pueda asignar uno nuevo de ataque.
    if (path_index == path_return) {
        path_end();
    }
    
    // ¡LIBERAR A LA BESTIA!
    // Al llamar a inherited, el padre toma el control:
    // - Usa su 'state' (PATROL/CHASE)
    // - Usa 'grid_ia' para buscar al jugador
    // - Gestiona colisiones con puertas (warps)
    event_inherited();
}