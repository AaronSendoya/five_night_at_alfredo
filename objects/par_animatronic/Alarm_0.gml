/// @description CEREBRO DE NAVEGACIÓN (Cercano/Lejano 50%)

if (state == "IDLE") {
    
    var _found = false;
    var _intentos = 0;
    var _tx, _ty;
    
    // =========================================================
    // DECISIÓN 1: ¿ME VOY DE LA SALA? (Paciencia Agotada)
    // =========================================================
    if (room_patience_timer <= 0) {
        
        var _best_warp = noone;
        
        // --- PASO A: FILTRAR CANDIDATOS VÁLIDOS ---
        // Creamos una lista solo con los warps que NO me devuelven atrás
        var _candidate_warps = ds_list_create();
        
        for (var i = 0; i < ds_list_size(interest_points); i++) {
            var _w = ds_list_find_value(interest_points, i);
            if (instance_exists(_w)) {
                // FILTRO: ¿Este warp me lleva a la sala de donde vengo?
                // Si es DIFERENTE, es un candidato válido.
                if (_w.target_room != last_room_visited) {
                    ds_list_add(_candidate_warps, _w);
                }
            }
        }
        
        // --- PASO B: ELEGIR EL MEJOR (CON PROBABILIDAD) ---
        
        // CASO 1: Tengo opciones válidas de avance
        if (ds_list_size(_candidate_warps) > 0) {
            
            // --- AQUÍ ESTÁ EL CAMBIO ---
            // Lanzamos una moneda: 0 = Cercano, 1 = Lejano
            var _estrategia = choose(0, 1);
            
            // ESTRATEGIA: BUSCAR EL MÁS CERCANO (Eficiencia)
            if (_estrategia == 0) {
                var _min_dist = 999999;
                for (var k = 0; k < ds_list_size(_candidate_warps); k++) {
                    var _valid_warp = ds_list_find_value(_candidate_warps, k);
                    var _d = point_distance(x, y, _valid_warp.x, _valid_warp.y);
                    if (_d < _min_dist) {
                        _min_dist = _d;
                        _best_warp = _valid_warp;
                    }
                }
            }
            
            // ESTRATEGIA: BUSCAR EL MÁS LEJANO (Impredecible / Cruzar sala)
            else {
                var _max_dist = -1; // Empezamos bajo para encontrar el mayor
                for (var k = 0; k < ds_list_size(_candidate_warps); k++) {
                    var _valid_warp = ds_list_find_value(_candidate_warps, k);
                    var _d = point_distance(x, y, _valid_warp.x, _valid_warp.y);
                    if (_d > _max_dist) { // Buscamos el mayor
                        _max_dist = _d;
                        _best_warp = _valid_warp;
                    }
                }
            }
        }
        
        // CASO 2: CALLEJÓN SIN SALIDA (No hay candidatos válidos)
        // Ejemplo: Estoy en una sala final y solo puedo volver atrás.
        else {
            // Aquí sí o sí buscamos el más cercano para salir rápido
            var _fallback_dist = 999999;
            for (var j = 0; j < ds_list_size(interest_points); j++) {
                var _any_warp = ds_list_find_value(interest_points, j);
                var _d2 = point_distance(x, y, _any_warp.x, _any_warp.y);
                if (_d2 < _fallback_dist) {
                    _fallback_dist = _d2;
                    _best_warp = _any_warp;
                }
            }
        }
        
        ds_list_destroy(_candidate_warps); // Limpiar memoria siempre
        
        // --- PASO C: EJECUTAR MOVIMIENTO ---
        if (_best_warp != noone) {
            _tx = _best_warp.x + 16; 
            _ty = _best_warp.y + 16;
            
            if (mp_grid_path(grid_ia, path, x, y, _tx, _ty, true)) {
                path_start(path, move_speed, path_action_stop, true);
                state = "MOVING";
                _found = true;
            }
        }
    }
    
    // =========================================================
    // DECISIÓN 2: EXPLORACIÓN LOCAL (Tengo paciencia)
    // =========================================================
    if (!_found) {
        
        while (_intentos < 20 && !_found) {
            _tx = irandom(room_width);
            _ty = irandom(room_height);
            
            _tx = (_tx div grid_cell_size) * grid_cell_size + 16;
            _ty = (_ty div grid_cell_size) * grid_cell_size + 16;
            
            if (point_distance(x, y, _tx, _ty) > 150) {
                if (mp_grid_path(grid_ia, path, x, y, _tx, _ty, true)) {
                    path_start(path, move_speed, path_action_stop, true); 
                    state = "MOVING";
                    _found = true;
                }
            }
            _intentos++;
        }
    }
    
    // Reintentar rápido si falló el cálculo
    if (!_found) alarm[0] = 5;
}