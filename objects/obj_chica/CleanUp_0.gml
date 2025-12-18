/// @description Limpiar Memoria GPS
if (path_exists(path_mission)) {
    path_delete(path_mission);
}
event_inherited();