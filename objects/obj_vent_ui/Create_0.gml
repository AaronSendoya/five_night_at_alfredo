/// @description Configuración del Monitor AAA

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// --- 1. CONFIGURACIÓN DE ESCALABILIDAD ---
// ¿Cuánto mide tu mundo REAL (Room) ahora mismo?
world_width_max = 6000;
world_height_max = 6600;

// --- 2. TAMAÑO DEL MAPA EN PANTALLA ---
// Lo haremos cuadrado, 600x600 px en el centro de la pantalla
map_display_size = 600;

map_x1 = (gui_w / 2) - (map_display_size / 2);
map_y1 = (gui_h / 2) - (map_display_size / 2);
// No necesitamos x2/y2, usaremos el tamaño

// Variable para animar las scanlines
time_counter = 0;