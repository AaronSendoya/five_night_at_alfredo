/// @description Control de Cámara (Monitor y Jugador)

// Activar/Desactivar monitor
if (keyboard_check_pressed(vk_tab)) global.en_camaras = !global.en_camaras;
// (Tu trigger de la tecla E también cambia esta variable, así que esto es compatible)


if (global.en_camaras) {
    // ------------------------------------------------
    // MODO MONITOR: Viajar con flechas
    // ------------------------------------------------
    if (keyboard_check_pressed(vk_right)) camara_actual++;
    if (keyboard_check_pressed(vk_left)) camara_actual--;
    
    if (camara_actual >= total_camaras) camara_actual = 0;
    if (camara_actual < 0) camara_actual = total_camaras - 1;

    // Mover vista a la cámara seleccionada
    camera_set_view_pos(view_camera[0], coords_camaras[camara_actual][0], coords_camaras[camara_actual][1]);

} else {
    // ------------------------------------------------
    // MODO JUGADOR: Detectar en qué sala estoy
    // ------------------------------------------------
    
    // Recorremos todas las zonas para ver en cuál está parado el jugador
    for (var i = 0; i < array_length(zonas_juego); i++) {
        
        var _zx = zonas_juego[i][0];
        var _zy = zonas_juego[i][1];
        
        // Comprobamos si el jugador está dentro del rectángulo de esta sala
        // (Le damos un margen extra de 2000px por si la sala es grande)
        if (point_in_rectangle(obj_jugador.x, obj_jugador.y, _zx, _zy, _zx + 3200, _zy + 2000)) {
            
    camera_set_view_pos(view_camera[0], _zx, _zy);
    break; 
}
    }
}