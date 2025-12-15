/// @description EJECUTAR EL VIAJE 

// NOTA: Aquí pegamos tu lógica, pero cambiamos "other.target_x" 
// por nuestras variables "warp_target_x", etc.

// 1. ¿Es un teletransporte en la misma sala?
if (warp_target_room == room) {
    x = warp_target_x;
    y = warp_target_y;
    
    state = "IDLE";
    
    // --- AQUÍ ESTÁ EL CAMBIO QUE PEDISTE (Inmóvil 0.5s) ---
    // En lugar de alarm[0] = 15, ponemos 30 (0.5 seg)
    alarm[0] = 30; 
    
    // Resetear paciencia
    if (is_active_by_level) room_patience_timer = room_patience_max;
}

// 2. ¿Es un viaje a OTRA sala?
else {
    if (instance_exists(obj_director_ia) && variable_global_exists("ubicaciones")) {
        
        // --- CORRECCIÓN 3: GUARDAR EN LA NUBE ---
        var _mis_datos = global.ubicaciones[? object_index];
        
        if (is_undefined(_mis_datos)) {
            _mis_datos = {};
            ds_map_add(global.ubicaciones, object_index, _mis_datos);
        }
        
        // Actualizamos dónde va a aparecer (USANDO LAS VARIABLES GUARDADAS)
        _mis_datos.sala = warp_target_room;
        _mis_datos.pos_x = warp_target_x;
        _mis_datos.pos_y = warp_target_y;
        
        _mis_datos.last_room = room; 
        
        instance_destroy();
    }
}