/// @description BUSCAR RUTA (RÁPIDA)

if (state == "IDLE") {
    
    var _found = false;
    var _intentos = 0;
    var _tx, _ty;
    
    // ESTRATEGIA: 70% Probabilidad de ir a PUERTA (Subí de 60 a 70 para más movimiento entre salas)
    if (irandom(100) < 70 && ds_list_size(interest_points) > 0) {
        var _warp = ds_list_find_value(interest_points, irandom(ds_list_size(interest_points)-1));
        if (instance_exists(_warp)) {
            _tx = _warp.x + 16; 
            _ty = _warp.y + 16;
            
            if (mp_grid_path(grid_ia, path, x, y, _tx, _ty, true)) {
                _found = true;
                path_start(path, move_speed, path_action_stop, true);
                state = "MOVING";
            }
        }
    }
    
    // Si no fue a puerta, buscar punto lejano
    while (_intentos < 20 && !_found) {
        _tx = irandom(room_width);
        _ty = irandom(room_height);
        
        _tx = (_tx div grid_cell_size) * grid_cell_size + 16;
        _ty = (_ty div grid_cell_size) * grid_cell_size + 16;
        
        // Filtro de distancia (>200px)
        if (point_distance(x, y, _tx, _ty) > 200) {
            if (mp_grid_path(grid_ia, path, x, y, _tx, _ty, true)) {
                _found = true;
                path_start(path, move_speed, path_action_stop, true); 
                state = "MOVING";
            }
        }
        _intentos++;
    }
    
    // CAMBIO IMPORTANTE: Si falla todo, reintentar MUY RÁPIDO
    // Antes era 30 (0.5 seg). Ahora es 5 frames.
    // Esto hace que si calcula mal, no se note la pausa "pensando".
    if (!_found) alarm[0] = 5;
}