/// @description DEBUG VISUAL

// 1. DIBUJAR SPRITE (Siempre que exista)
if (sprite_exists(sprite_index)) {
    draw_self();
}

// 2. DEBUG (Solo si está activo el modo debug global)
//if (global.debug_mode) {
//    draw_set_alpha(0.1);
    
//    // Color según estado: Rojo (Cazando/Oscuridad), Azul (Volviendo/Luz)
//    if (global.power_on) draw_set_color(c_blue);
//    else draw_set_color(c_red);
    
//    // Dibujar rango de visión
//    draw_circle(x, y, view_dist, true); 
    
//    draw_set_alpha(1);
//    draw_set_color(c_white);
    
//    // Dibujar ruta activa (sea la del padre o la de retorno)
//    if (path_exists(path_index) && path_position < 1) {
//        draw_path(path_index, x, y, true);
//    }
//}