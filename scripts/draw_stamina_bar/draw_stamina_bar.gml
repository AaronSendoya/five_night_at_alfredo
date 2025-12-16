// ESTO VA DENTRO DEL SCRIPT (ej. scr_ui_functions o draw_stamina_bar)
function draw_stamina_bar(_x, _y, _val_actual, _val_max, _cooldown, _is_running) {
    // --- CONFIGURACIÓN VISUAL ---
    var _w = 300; 
    var _h = 20;
    var _pct = clamp(_val_actual / _val_max, 0, 1);

    var _x2 = _x + _w;
    var _y2 = _y + _h;

    // --- COLORES ---
    var _c1, _c2, _glow;
    if (_cooldown > 0) {
        _c1 = c_maroon; _c2 = c_red; _glow = c_red;
    } else if (_is_running) {
        _c1 = make_color_rgb(180, 100, 0); _c2 = c_yellow; _glow = c_orange;
    } else {
        _c1 = make_color_rgb(0, 80, 160); _c2 = c_aqua; _glow = make_color_rgb(100, 255, 255);
    }

    // --- DIBUJADO ---
    draw_set_color(c_black); draw_set_alpha(0.6);
    draw_rectangle(_x - 4, _y - 4, _x2 + 4, _y2 + 4, false); // Fondo

    draw_set_color(make_color_rgb(20, 20, 30)); draw_set_alpha(0.8);
    draw_rectangle(_x, _y, _x2, _y2, false); // Canal vacío

    var _fill_w = _w * _pct;
    if (_fill_w > 0) {
        draw_set_alpha(1);
        draw_rectangle_color(_x, _y, _x + _fill_w, _y2, _c1, _c2, _c2, _c1, false); // Barra

        gpu_set_blendmode(bm_add);
        draw_set_color(_glow); draw_set_alpha(0.2);
        draw_rectangle(_x, _y, _x + _fill_w, _y2, false); // Brillo

        // Partículas
        var _tip_x = _x + _fill_w;
        var _mid_y = _y + (_h / 2);
        draw_set_alpha(0.8);
        for (var i = 0; i < 5; i++) {
            var _time = (current_time / 150) + (i * 100);
            var _px = _tip_x - abs(sin(_time) * 10);
            var _py = _mid_y + (cos(_time * 2.1) * 6);
            var _size = 1 + (sin(_time * 5) * 1);
            draw_circle(_px, _py, _size, false);
        }
        gpu_set_blendmode(bm_normal);
    }

    draw_set_color(c_white); draw_set_alpha(0.9);
    draw_rectangle(_x - 2, _y - 2, _x2 + 2, _y2 + 2, true); // Marco
    draw_set_halign(fa_right); draw_set_valign(fa_bottom);
    draw_text(_x2, _y - 5, "STAMINA"); 
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_alpha(1); draw_set_color(c_white);
}