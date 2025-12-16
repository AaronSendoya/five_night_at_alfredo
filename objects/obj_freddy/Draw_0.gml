/// @description DEBUG VISUAL

// 1. DIBUJAR SPRITE
if (sprite_exists(sprite_index)) {
    draw_self();
}

// 2. DEBUG (Solo si activas el modo debug global)
if (global.debug_mode) {
    draw_set_alpha(0.1);
    
    if (is_rushing) {
        // Solo para que tú sepas que está corriendo (debug), el jugador no verá esto
        draw_set_color(c_red); 
        draw_circle(x, y, view_dist, true);
        draw_set_alpha(1);
        draw_text(x, y - 60, "RUSH!");
    } else {
        draw_set_color(c_white);
        draw_circle(x, y, view_dist, true);
    }
    
    draw_set_alpha(1);
    draw_set_color(c_white);
    
    if (path_exists(path)) {
        draw_set_color(c_maroon);
        draw_path(path, x, y, true);
        draw_set_color(c_white);
    }
}