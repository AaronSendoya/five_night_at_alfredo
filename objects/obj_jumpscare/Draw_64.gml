flash_timer++;

// Obtener tamaño de pantalla
var _w = display_get_gui_width();
var _h = display_get_gui_height();

// EFECTO DE PARPADEO (Strobe effect)
// Cada 4 frames cambia entre dibujar negro y no dibujar nada
if (flash_timer mod 4 < 2) {
    draw_set_color(c_black);
    draw_set_alpha(1);
    draw_rectangle(0, 0, _w, _h, false);
}

// Opcional: Si quieres dibujar la cara del monstruo aquí también
// draw_sprite(spr_jumpscare_face, 0, _w/2, _h/2);

draw_set_color(c_white); // Resetear color