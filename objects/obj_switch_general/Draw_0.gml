draw_self();

if (mostrar_mensaje) {
    draw_set_halign(fa_center);
    draw_text(x, y - 40, is_on ? "[E] Apagar" : "[E] Encender");
    draw_set_halign(fa_left);
}