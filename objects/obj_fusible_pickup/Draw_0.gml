/// @description Dibujar Item + Aviso

// Dibujar el sprite con la pequeña flotación
draw_sprite(sprite_index, image_index, x, y + float_y);

// Dibujar aviso "E" si está cerca
if (mostrar_mensaje) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    
    // Si ya tienes uno, avisa que está lleno
    if (global.has_fuse) {
        draw_set_color(c_red);
        draw_text(x, y - 20, "Inventario Lleno");
    } else {
        draw_set_color(c_yellow);
        draw_text(x, y - 20, "[E] Recoger Fusible");
    }
    
    // Resetear colores
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}