// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function registrar_viaje(_objeto, _nueva_room, _nuevo_x, _nuevo_y) {
    var _nuevos_datos = {
        sala: _nueva_room,
        pos_x: _nuevo_x,
        pos_y: _nuevo_y
    };
    
    // Guardar en el mapa global (sobreescribe lo anterior)
    ds_map_add(global.ubicaciones, _objeto, _nuevos_datos);
    
    show_debug_message("DIRECTOR: " + object_get_name(_objeto) + " se movió a " + room_get_name(_nueva_room));
}