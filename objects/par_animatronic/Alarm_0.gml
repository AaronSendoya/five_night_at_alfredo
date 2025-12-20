/// @description CEREBRO DE NAVEGACIÓN (Corregido)

if (state == "IDLE") {
    
    var _found = false;
    var _tx, _ty;
    
    // Bajar paciencia
    room_patience_timer -= 60; 

    // =========================================================
    // DECISIÓN 1: CAMBIAR DE SALA (PRIORIDAD SI SE ACABÓ EL TIEMPO)
    // =========================================================
    if (room_patience_timer <= 0) {
        
        var _best_warp = noone;
        var _candidate_warps = ds_list_create();
        
        // 1. Recolectar Warps
        for (var i = 0; i < ds_list_size(interest_points); i++) {
            var _w = ds_list_find_value(interest_points, i);
            if (instance_exists(_w)) {
                ds_list_add(_candidate_warps, _w);
            }
        }
        
        // 2. Elegir Warp al azar (Impredecible)
        if (ds_list_size(_candidate_warps) > 0) {
            var _idx = irandom(ds_list_size(_candidate_warps) - 1);
            _best_warp = ds_list_find_value(_candidate_warps, _idx);
        }
        
        ds_list_destroy(_candidate_warps);
        
        // 3. Ejecutar Movimiento hacia el Warp
        if (_best_warp != noone) {
            _tx = _best_warp.x + 16; 
            _ty = _best_warp.y + 16;
            
            if (mp_grid_path(grid_ia, path, x, y, _tx, _ty, true)) {
                path_start(path, move_speed, path_action_stop, true);
                state = "MOVING";
                _found = true;
                room_patience_timer = room_patience_max; 
            }
        }
    }
    
    // =========================================================
    // DECISIÓN 2: MOVERSE DENTRO DE LA SALA (Exploración Local)
    // =========================================================
    if (!_found) {
        
        var _intentos = 0;
        var _distancia_minima = 50; 
        
        // Aumentamos intentos a 15 porque tu mapa tiene mucho "vacío"
        while (_intentos < 15 && !_found) { 
            
            // --- CORRECCIÓN IMPORTANTE: CHEQUEO DE JUGADOR ESCONDIDO ---
            // Solo va hacia el jugador si existe Y NO ESTÁ ESCONDIDO
            if (_intentos == 0 && instance_exists(obj_jugador) && !global.player_hidden) {
                _tx = obj_jugador.x;
                _ty = obj_jugador.y;
            } else {
                // Aleatorio (Evitando bordes extremos)
                _tx = irandom_range(32, room_width - 32);
                _ty = irandom_range(32, room_height - 32);
                
                // Ajustar a grilla (Snap)
                _tx = (_tx div grid_cell_size) * grid_cell_size + 16;
                _ty = (_ty div grid_cell_size) * grid_cell_size + 16;
            }
            
            // Verificamos distancia y si hay camino válido
            if (point_distance(x, y, _tx, _ty) > _distancia_minima) {
                // mp_grid_path devolverá FALSE si el punto cae en el vacío negro de tu mapa
                if (mp_grid_path(grid_ia, path, x, y, _tx, _ty, true)) {
                    path_start(path, move_speed, path_action_stop, true); 
                    state = "MOVING";
                    _found = true;
                }
            }
            _intentos++;
        }
    }
    
    // =========================================================
    // FALLBACK (PLAN C)
    // =========================================================
    // Si falló todo (probablemente porque eligió puntos en el vacío), reintentar YA.
    if (!_found) {
        alarm[0] = 5; 
    }
}