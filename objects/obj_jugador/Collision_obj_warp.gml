/// @description Iniciar Transición Suave

// 1. Comprobar que no haya ya una transición en curso (para evitar bugs)
if (!instance_exists(obj_transicion)) {
    
    // 2. Crear el objeto de transición (en una capa muy alta para que tape todo)
    var _trans = instance_create_depth(0, 0, -9999, obj_transicion);
    
    // 3. Pasarle los datos del Warp (el bloque azul) a la Transición
    // El objeto transición guardará estos datos y te moverá cuando la pantalla esté negra.
    _trans.target_x = other.target_x;
    _trans.target_y = other.target_y;
    _trans.target_sprite = other.sprite_llegada;
    
    // ¡IMPORTANTE! Aquí NO ponemos "x = other.target_x". 
    // Si lo pusiéramos, te moverías antes de que se oscurezca la pantalla.
}