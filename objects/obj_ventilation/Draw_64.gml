/// @description UI: Barras, Mensajes y Carga

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2; 

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// =========================================================================
// CASO A: ESTOY DENTRO (BARRA DE OXÍGENO)
// =========================================================================
if (instance_exists(obj_vent_ui) && global.current_vent_id == id) {
    
    var _ancho = 300;
    var _alto  = 12;
    var _y_barra = _gh - 50; 
    
    var _x1 = _cx - (_ancho / 2);
    var _y1 = _y_barra;
    var _x2 = _cx + (_ancho / 2);
    var _y2 = _y_barra + _alto;
    
    var _pct = hide_time_current / hide_time_max;
    
    draw_set_alpha(0.8);
    draw_set_color(c_dkgray);
    draw_rectangle(_x1 - 2, _y1 - 2, _x2 + 2, _y2 + 2, false);
    
    var _col = c_aqua;
    if (_pct < 0.5) _col = c_orange;
    if (_pct < 0.25) _col = c_red;
    
    draw_set_alpha(1);
    draw_set_color(_col);
    draw_rectangle(_x1, _y1, _x1 + (_ancho * _pct), _y2, false);
    
    draw_set_color(c_white);
    if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso); 
    else draw_set_font(-1);
    
    draw_text(_cx, _y1 - 5, "OXIGENO: " + string(ceil(hide_time_current/60)) + "s");
}

// =========================================================================
// CASO B: ESTOY FUERA (MANTENER E / COOLDOWN)
// =========================================================================
else if (mostrar_mensaje && !instance_exists(obj_vent_ui)) {
    
    // 1. SI HAY COOLDOWN
    if (hide_cooldown > 0) {
        var _seg = ceil(hide_cooldown / 60);
        draw_set_color(c_red);
        if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso);
        
        draw_text(_cx, _gh - 50, "PURGANDO AIRE...: " + string(_seg) + "s");
        var _recarga_pct = hide_cooldown / hide_cooldown_max;
        draw_rectangle(_cx - 50, _gh - 45, _cx - 50 + (100 * _recarga_pct), _gh - 40, false);
    }
    
    // 2. DISPONIBLE (CON EFECTO DE CARGA AL MANTENER)
    else {
        
        // --- DIBUJAR CARGA DE ENTRADA ---
        if (entry_timer > 0) {
            // Dibujamos un círculo o barra de carga pequeña
            var _load_pct = entry_timer / entry_max;
            
            draw_set_color(c_lime);
            // Barra de carga rápida debajo del texto
            draw_rectangle(_cx - 60, _gh - 40, _cx - 60 + (120 * _load_pct), _gh - 35, false);
            
            draw_set_color(c_white);
            if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso);
            draw_text(_cx, _gh - 50, "ACCEDIENDO...");
        } 
        else {
            // Texto normal
            draw_set_color(c_white);
            if (font_exists(fnt_aviso)) draw_set_font(fnt_aviso);
            
            draw_set_color(c_black);
            draw_text(_cx + 2, _gh - 48, "Manten presionado [E] para Entrar");
            
            draw_set_color(c_white);
            draw_text(_cx, _gh - 50, "Manten presionado [E] para Entrar");
        }
    }
}

// Resetear
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_alpha(1);