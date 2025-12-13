/// @description Dibujar Interfaz (Limpio)

// 1. Obtener dimensiones de la pantalla
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// 2. Definir posición (Inferior Derecha)
// NOTA: Si en tu script pusiste ancho 300, usa 300 aquí. Si pusiste 350, cambia el 300 por 350.
var _ancho_barra = 300; 
var _alto_barra = 20;
var _margen = 50;

var _x_pos = _gw - _ancho_barra - _margen;
var _y_pos = _gh - _alto_barra - _margen;

// 3. ¡AQUÍ ESTÁ LA MAGIA! Llamamos a tu función nueva
draw_stamina_bar(
    _x_pos, 
    _y_pos, 
    sprint_actual, 
    sprint_max, 
    sprint_cooldown, 
    corriendo
);