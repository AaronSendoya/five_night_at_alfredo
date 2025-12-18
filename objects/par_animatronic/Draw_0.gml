/// @description DEBUG VISUAL (Ruta + Visión)

// =============================================================
// 1. DIBUJO DEL SPRITE (CON PROTECCIÓN ANTI-CRASH)
// =============================================================
// Verificamos si existe un sprite asignado antes de intentar dibujarlo.
if (sprite_exists(sprite_index)) {
    draw_self();
}

//// =============================================================
//// 2. DIBUJAR CAMPO DE VISIÓN (Cono)
//// =============================================================
//var _fov_angle = 150; 
//var _view_dist = 1100; 
//var _segments = 20;   

//draw_set_alpha(0.2);  
//if (variable_instance_exists(id, "state") && state == "CHASE") {
//    draw_set_color(c_red); 
//} else {
//    draw_set_color(c_yellow);                
//}

//draw_primitive_begin(pr_trianglefan);
//draw_vertex(x, y); // Centro

//for (var i = 0; i <= _segments; i++) {
//    // Calcular arco
//    var _total_span = _fov_angle * 2; 
//    var _angle_step = _total_span / _segments;
//    var _current_angle = (direction - _fov_angle) + (i * _angle_step);
    
//    var _px = x + lengthdir_x(_view_dist, _current_angle);
//    var _py = y + lengthdir_y(_view_dist, _current_angle);
    
//    draw_vertex(_px, _py);
//}
//draw_primitive_end();

//// Resetear colores
//draw_set_alpha(1);
//draw_set_color(c_white);

// =============================================================
// 3. DIBUJAR RUTA (Línea roja)
// =============================================================
//if (path_exists(path) && path_get_number(path) > 0) {
//    draw_set_color(c_red);
//    draw_path(path, x, y, true);
//}

// Si Chica tiene su path propio de misión, dibujémoslo también (Color Azul)
//if (variable_instance_exists(id, "path_mission")) {
//    if (path_exists(path_mission) && path_get_number(path_mission) > 0) {
//        draw_set_color(c_aqua); // Azul claro para diferenciar
//        draw_path(path_mission, x, y, true);
//    }
//}

//// Reset final
//draw_set_color(c_white);