/// @description Iniciar Transición

// Comprobamos si ya existe una transición para no crear 50 a la vez
if (!instance_exists(obj_transicion)) {
    
    // Creamos el objeto transición
    var _inst = instance_create_depth(0, 0, -9999, obj_transicion);
    
    // Le pasamos los datos que tiene el Warp
    _inst.target_room = other.sala_destino;
    _inst.target_x = other.target_x;
    _inst.target_y = other.target_y;
    _inst.target_sprite = other.sprite_llegada; // La variable nueva del paso 1
}