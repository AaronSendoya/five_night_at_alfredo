/// @description Spawnear Animatrónicos

// Recorrer el mapa de ubicaciones
var _k = ds_map_find_first(global.ubicaciones);

while (!is_undefined(_k)) {
    // _k es el ID del objeto (ej. obj_bonnie_guitarra)
    var _datos = global.ubicaciones[? _k];
    
    // VERIFICACIÓN: ¿El animatrónico está en ESTA sala actual?
    if (_datos.sala == room) {
        // ¿Ya existe? (Para evitar duplicados si la room es persistente)
        if (!instance_exists(_k)) {
            // ¡SPAWN! Lo creamos en las coordenadas guardadas
            var _inst = instance_create_layer(_datos.pos_x, _datos.pos_y, "Instances", _k);
            
            // Opcional: Le decimos que espere un segundo antes de moverse
            _inst.alarm[0] = 60; 
            _inst.state = "IDLE";
        }
    }
    
    _k = ds_map_find_next(global.ubicaciones, _k);
}