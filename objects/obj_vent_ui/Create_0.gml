/// @description Configuración del Monitor
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// Dimensiones del mapa
map_width = 600;
map_height = 400;

// Calcular coordenadas centradas
map_x1 = (gui_w / 2) - (map_width / 2);
map_y1 = (gui_h / 2) - (map_height / 2);
map_x2 = map_x1 + map_width;
map_y2 = map_y1 + map_height;