/// @description Dibujar el efecto (SOLO EN MANTENIMIENTO)

// 1. Averiguar dónde está mirando la cámara ahora mismo
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);

// 2. Coordenadas EXACTAS de tu sala de Mantenimiento
// (Las sacamos de tu lista anterior: 3071, 1663)
var _sala_mantenimiento_x = 3071;
var _sala_mantenimiento_y = 1663;

// 3. Comprobar si la cámara está ahí
// Usamos "abs" (valor absoluto) para dar un pequeño margen de error de 10 píxeles
// por si la cámara no se alineó perfecta al milímetro.
var _estoy_viendo_mantenimiento = (abs(_cam_x - _sala_mantenimiento_x) < 10) && (abs(_cam_y - _sala_mantenimiento_y) < 10);

// 4. DIBUJAR
// Solo si hay oscuridad (alpha > 0) Y estamos viendo la sala correcta
if (alpha > 0 && _estoy_viendo_mantenimiento) {
    
    draw_set_color(c_black);
    draw_set_alpha(alpha);
    
    // Dibuja un rectángulo negro que cubre toda la pantalla
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // Restablecer para no afectar a otros dibujos
    draw_set_alpha(1);
    draw_set_color(c_white);
}