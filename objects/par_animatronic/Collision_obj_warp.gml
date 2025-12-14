/// @description SISTEMA DE VIAJE

path_end();

// 1. ¿Es un teletransporte en la misma sala?
if (other.target_room == room) {
    x = other.target_x;
    y = other.target_y;
    state = "IDLE";
    alarm[0] = 15;
}
// 2. ¿Es un viaje a OTRA sala?
else {
    // Verificamos que el Director exista para que guarde el dato
    if (instance_exists(obj_director_ia)) {
        // Como 'registrar_viaje' ahora es un Script, lo llamamos directo
        registrar_viaje(object_index, other.target_room, other.target_x, other.target_y);
        
        // Destruimos al animatrónico físico
        instance_destroy();
    }
}