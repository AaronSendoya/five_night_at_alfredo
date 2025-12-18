/// @description Interfaz de Escondite y Barra de Aire

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// =========================================================================
// CASO A: ESTOY DENTRO (BARRA DE AIRE / OXÍGENO)
// =========================================================================
if (escondido_aqui) {
    
    // Configuración de la barra
    var _ancho = 300;
    var _alto  = 12;
    var _y_barra = _gh - 100; // Posición vertical
    
    var _x1 = _cx - (_ancho / 2);
    var _y1 = _y_barra;
    var _x2 = _cx + (_ancho / 2);
    var _y2 = _y_barra + _alto;
    
    var _pct = hide_time_current / hide_time_max;
    
    // 1. FONDO DE LA BARRA (Gris oscuro)
    draw_set_alpha(0.8);
    draw_set_color(c_dkgray);
    draw_rectangle(_x1 - 2, _y1 - 2, _x2 + 2, _y2 + 2, false);
    
    // 2. BARRA DE PROGRESO (Cambia de color: Azul -> Naranja -> Rojo)
    var _col = c_aqua; // Color aire normal
    if (_pct < 0.5) _col = c_orange;
    if (_pct < 0.25) _col = c_red;
    
    draw_set_alpha(1);
    draw_set_color(_col);
    draw_rectangle(_x1, _y1, _x1 + (_ancho * _pct), _y2, false);
    
    // 3. TEXTO INDICADOR
    draw_set_color(c_white);
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small); // Usa tu fuente si tienes
    else draw_set_font(-1);
    
    draw_text(_cx, _y1 - 5, "SIGILO COMPROMETIDO EN: " + string(ceil(hide_time_current/60)) + "s");
    
    // 4. AVISO DE SALIDA (Más abajo)
    draw_set_alpha(0.6);
    draw_text(_cx, _y1 + 40, "[E] SALIR");
    draw_set_alpha(1);
}

// =========================================================================
// CASO B: ESTOY FUERA (INTERACCIÓN O COOLDOWN)
// =========================================================================
else if (mostrar_mensaje && !global.player_hidden) {
    
    // SI HAY COOLDOWN (Mostrar en Rojo)
    if (hide_cooldown > 0) {
        var _seg = ceil(hide_cooldown / 60);
        draw_set_color(c_red);
        draw_text(_cx, _gh - 80, "¡AGOTADO! ESPERA " + string(_seg) + "s");
        
        // Barrita roja pequeña de recarga
        var _recarga_pct = hide_cooldown / hide_cooldown_max;
        draw_rectangle(_cx - 50, _gh - 75, _cx - 50 + (100 * _recarga_pct), _gh - 70, false);
    } 
    // SI ESTÁ LISTO (Mostrar en Blanco/Azul)
    else {
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_roundrect(_cx - 120, _gh - 100, _cx + 120, _gh - 60, false);
        
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_text(_cx, _gh - 70, "[E] ESCONDERSE");
    }
}

// Resetear
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);