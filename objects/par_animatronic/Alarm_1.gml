/// @description EJECUTAR EL VIAJE (Warp Finish)

// 1. ¿Es un teletransporte en la misma sala?
if (warp_target_room == room) {
    x = warp_target_x;
    y = warp_target_y;
    
    state = "IDLE";
    
    // Pausa breve al aparecer (0.5s)
    alarm[0] = 30; 
    
    // Resetear paciencia
    if (is_active_by_level) room_patience_timer = room_patience_max;
}

// 2. ¿Es un viaje a OTRA sala?
else {
    if (instance_exists(obj_director_ia) && variable_global_exists("ubicaciones")) {
        
        var _mis_datos = global.ubicaciones[? object_index];
        
        // Si no existe la estructura, la creamos
        if (is_undefined(_mis_datos)) {
            _mis_datos = {};
            ds_map_add(global.ubicaciones, object_index, _mis_datos);
        }
        
        // Guardamos los datos para que el Director IA nos respawnee allá
        _mis_datos.sala = warp_target_room;
        _mis_datos.pos_x = warp_target_x;
        _mis_datos.pos_y = warp_target_y;
        
        // Guardar de dónde venimos
        _mis_datos.last_room = room; 
        
        // Desaparecer de esta sala
        instance_destroy();
    }
}