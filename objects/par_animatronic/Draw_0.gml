/// @description DEBUG VISUAL (Ruta + Visión)

draw_self();

// --- 1. DIBUJAR CAMPO DE VISIÓN (Cono) ---
var _fov_angle = 120; // DEBE COINCIDIR CON EL STEP (120)
var _view_dist = 990; // DEBE COINCIDIR CON EL STEP (250)
var _segments = 20;   // Calidad del dibujo

draw_set_alpha(0.2);  // Transparencia
if (state == "CHASE") draw_set_color(c_red); // Rojo si te caza
else draw_set_color(c_yellow);               // Amarillo si patrulla

draw_primitive_begin(pr_trianglefan);
draw_vertex(x, y); // Centro

for (var i = 0; i <= _segments; i++) {
    // Calcular arco
    var _total_span = _fov_angle * 2; 
    var _angle_step = _total_span / _segments;
    var _current_angle = (direction - _fov_angle) + (i * _angle_step);
    
    var _px = x + lengthdir_x(_view_dist, _current_angle);
    var _py = y + lengthdir_y(_view_dist, _current_angle);
    
    draw_vertex(_px, _py);
}
draw_primitive_end();

// Resetear
draw_set_alpha(1);
draw_set_color(c_white);

// --- 2. DIBUJAR RUTA (Línea roja) ---
if (path_exists(path) && path_get_number(path) > 0) {
    draw_set_color(c_red);
    draw_path(path, x, y, true);
}