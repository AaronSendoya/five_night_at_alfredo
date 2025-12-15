/// @description Interfaz de Texto con Efectos Profesionales

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// CASO A: ESTOY FUERA -> "ESCONDERSE"
if (mostrar_mensaje && !escondido_aqui) {
    
    if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso);
    
    var _cx = _gw / 2;
    var _cy = _gh - 60;
    
    // Panel semi-transparente de fondo
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_roundrect_ext(_cx - 200, _cy - 35, _cx + 200, _cy + 5, 6, 6, false);
    draw_set_alpha(1);
    
    // Borde sutil
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(80, 80, 80));
    draw_roundrect_ext(_cx - 200, _cy - 35, _cx + 200, _cy + 5, 6, 6, true);
    draw_set_alpha(1);
    
    // Pulso suave en el texto
    var _text_pulse = (sin(current_time / 200) * 0.15) + 0.85;
    
    // Sombra del texto
    draw_set_color(c_black);
    draw_text_transformed(_cx + 2, _cy - 13, "Presiona [E] para Esconderte", _text_pulse, _text_pulse, 0);
    
    // Texto principal
    draw_set_color(c_white);
    draw_text_transformed(_cx, _cy - 15, "Presiona [E] para Esconderte", _text_pulse, _text_pulse, 0);
}

// CASO B: ESTOY DENTRO -> "SALIR" (Con animación de alerta)
if (escondido_aqui) {
    
    if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso);
    
    var _cx = _gw / 2;
    var _cy = _gh - 60;
    
    // Panel con color rojizo (peligro)
    draw_set_alpha(0.7);
    draw_set_color(make_color_rgb(20, 10, 10));
    draw_roundrect_ext(_cx - 180, _cy - 35, _cx + 180, _cy + 5, 6, 6, false);
    draw_set_alpha(1);
    
    // Borde pulsante amarillo (advertencia)
    var _border_pulse = (sin(current_time / 150) * 0.4) + 0.6;
    draw_set_alpha(_border_pulse);
    draw_set_color(c_yellow);
    draw_roundrect_ext(_cx - 180, _cy - 35, _cx + 180, _cy + 5, 6, 6, true);
    draw_set_alpha(1);
    
    // Texto pulsante más rápido (urgencia)
    var _text_pulse = (sin(current_time / 150) * 0.2) + 0.9;
    
    // Sombra
    draw_set_color(c_black);
    draw_text_transformed(_cx + 2, _cy - 13, "Presiona [E] para Salir", _text_pulse, _text_pulse, 0);
    
    // Texto amarillo (alerta)
    draw_set_color(c_yellow);
    draw_text_transformed(_cx, _cy - 15, "Presiona [E] para Salir", _text_pulse, _text_pulse, 0);
}

// Resetear propiedades
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_color(c_white);


// =========================================================================
// BONUS: EFECTO VISUAL CUANDO ESTÁS ESCONDIDO (Agregar al Draw GUI)
// =========================================================================

/// @description Efecto de Vista Limitada Cuando Estás Escondido

if (escondido_aqui) {
    
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    
    // Viñeta oscura pesada (vista limitada)
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    
    // Bordes oscuros para simular vista desde el escondite
    draw_rectangle(0, 0, _gw, 120, false); // Superior
    draw_rectangle(0, _gh - 120, _gw, _gh, false); // Inferior
    draw_rectangle(0, 0, 100, _gh, false); // Izquierda
    draw_rectangle(_gw - 100, 0, _gw, _gh, false); // Derecha
    
    draw_set_alpha(1);
    
    // Efecto de respiración (pantalla sube y baja ligeramente)
    var _breathing = sin(current_time / 1000) * 2;
    
    // Líneas sutiles simulando rendijas del escondite
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    for (var i = 0; i < 8; i++) {
        var _line_y = (_gh / 8) * i + _breathing;
        draw_line_width(0, _line_y, _gw, _line_y, 2);
    }
    draw_set_alpha(1);
    
    // Indicador de estado "ESCONDIDO" en la esquina
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small);
    
    var _status_alpha = (sin(current_time / 400) * 0.3) + 0.7;
    draw_set_alpha(_status_alpha);
    
    // Sombra
    draw_set_color(c_black);
    draw_text(22, 22, "OCULTO");
    
    // Texto
    draw_set_color(make_color_rgb(100, 180, 100));
    draw_text(20, 20, "OCULTO");
    
    draw_set_alpha(1);
    draw_set_font(-1);
}

// Resetear todo
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);