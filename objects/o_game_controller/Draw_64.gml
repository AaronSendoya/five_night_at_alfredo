/// @description Dibujado de UI Profesional (Draw GUI Event)

var _w = display_get_gui_width();
var _h = display_get_gui_height();

// ---------------------------------------------------------
// CASO A: INTRODUCCIÓN (PANTALLA NEGRA MINIMALISTA)
// ---------------------------------------------------------
if (visual_state == "INTRO") {
    // Fondo negro puro
    draw_set_color(c_black);
    draw_rectangle(0, 0, _w, _h, false);
    
    // Animación de fade in suave
    var _fade = clamp(1 - (intro_timer / 180), 0, 1);
    draw_set_alpha(_fade);
    
    // Configuración de texto centrado
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Hora principal
    if (font_exists(fnt_pixel)) draw_set_font(fnt_pixel);
    draw_set_color(c_white);
    draw_text(_w / 2, _h / 2, "12:00 AM");
    
    // Texto de noche
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small);
    draw_set_color(make_color_rgb(140, 140, 140));
    draw_text(_w / 2, (_h / 2) + 50, "Night " + string(global.current_night));
    
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// CASO B: JUEGO (RELOJ DISCRETO Y FUNCIONAL)
// ---------------------------------------------------------
else if (visual_state == "GAME") {
    // Formatear hora
    var _min_str = string(current_minute_display);
    if (current_minute_display < 10) _min_str = "0" + _min_str;
    var _clock_str = string(current_hour_display) + ":" + _min_str + " AM";
    
    // Configuración para esquina superior derecha
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    
    // Hora - Color gris apagado
    if (font_exists(fnt_pixel)) draw_set_font(fnt_pixel);
    draw_set_color(make_color_rgb(190, 190, 190));
    draw_text(_w - 20, 20, _clock_str);
    
    // Noche actual - Más oscuro
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small);
    draw_set_color(make_color_rgb(110, 110, 110));
    draw_text(_w - 20, 48, "Night " + string(global.current_night));
}

// ---------------------------------------------------------
// CASO C: VICTORIA (CONFETI Y 6 AM - MOMENTO DE ALIVIO)
// ---------------------------------------------------------
else if (visual_state == "OUTRO") {
    // Fondo negro
    draw_set_color(c_black);
    draw_rectangle(0, 0, _w, _h, false);
    
    // Dibujar Confeti - Círculos de colores
    for (var i = 0; i < confetti_count; i++) {
        var _p = confetti_particles[i];
        draw_set_color(_p.col);
        draw_circle(_p.x, _p.y, 5, false);
    }
    
    // Configuración centrada
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Hora 6 AM
    if (font_exists(fnt_pixel)) draw_set_font(fnt_pixel);
    draw_set_color(c_white);
    draw_text(_w / 2, _h / 2, "6:00 AM");
    
    // Mensaje de felicitación
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small);
    draw_set_color(make_color_rgb(170, 170, 170));
    draw_text(_w / 2, (_h / 2) + 60, "Night Complete");
}

// ---------------------------------------------------------
// RESETEO DE PROPIEDADES DE DIBUJO
// ---------------------------------------------------------
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);