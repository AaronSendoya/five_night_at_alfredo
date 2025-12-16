/// @description UI: Progreso y Advertencias

var _cw = display_get_gui_width();
var _ch = display_get_gui_height();
var _cx = _cw / 2;
var _cy = _ch / 2;

// =========================================================
// 1. BARRA DE PROGRESO CIRCULAR (REPARANDO)
// =========================================================
if (is_repairing) {
    var _radius = 40; // Tamaño del círculo
    
    // A. Fondo del círculo (Anillo Gris oscuro)
    draw_set_color(c_dkgray);
    draw_circle(_cx, _cy, _radius, true); // Borde externo
    draw_circle(_cx, _cy, _radius - 1, true); // Borde interno (grosor)
    
    // B. Arco de Progreso (Color Aqua)
    var _val = repair_timer / repair_time_max; // 0.0 a 1.0
    var _angle_max = 360 * _val;
    var _steps = 40; // Calidad del círculo (suavidad)
    
    draw_set_color(c_aqua); 
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx, _cy); // Centro del abanico
    
    for(var i = 0; i <= _steps; i++) {
        var _angle_curr = 90 - (i / _steps) * 360; // Empezar desde las 12 en punto
        
        // Si nos pasamos del progreso actual, paramos de dibujar
        if ((i / _steps) * 360 > _angle_max) break;
        
        var _px = _cx + lengthdir_x(_radius, _angle_curr);
        var _py = _cy + lengthdir_y(_radius, _angle_curr);
        draw_vertex(_px, _py);
    }
    draw_primitive_end();
    
    // C. Texto de porcentaje en el centro
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_cx, _cy, string(round(_val * 100)) + "%");
    
    // Resetear alineación temporalmente
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// =========================================================
// 2. SISTEMA DE ADVERTENCIA (FUSIBLE QUEMADO)
// =========================================================
// Esto se activa automáticamente cuando se destruye un fusible
if (warning_timer > 0) {
    
    // Configuración de Texto
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (font_exists(fnt_pixel_small)) draw_set_font(fnt_pixel_small);
    
    // Lógica de Parpadeo: Visible/Invisible cada 10 frames para dar urgencia
    // (Los primeros 20 frames es fijo, luego parpadea)
    var _blink = (warning_timer div 10) % 2; 
    
    if (_blink == 0 || warning_timer > (warning_duration - 20)) {
        
        // A. Fondo Rojo Semitransparente (Banda horizontal)
        // Dibujamos en el cuarto superior de la pantalla (_ch/4)
        var _bar_y = _ch / 4;
        draw_set_color(c_red);
        draw_set_alpha(0.3); 
        draw_rectangle(0, _bar_y - 30, _cw, _bar_y + 30, false);
        
        // B. Texto con Sombra (Negra, desplazada 2px)
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_text(_cx + 2, _bar_y + 2, warning_text);
        
        // C. Texto Principal (Rojo brillante)
        draw_set_color(c_red);
        draw_text(_cx, _bar_y, warning_text);
    }
    
    // RESETEAR TODO AL FINAL
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}