/// @description Dibujar Barra de Stamina (Profesional - Inferior Derecha)

// 1. Obtener dimensiones de la pantalla
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// 2. Definir posición (Inferior DERECHA como el original)
var _ancho_barra = 270;
var _alto_barra = 18;
var _margen = 50;
var _x_pos = _gw - _ancho_barra - _margen;
var _y_pos = _gh - _alto_barra - _margen;

// ---------------------------------------------------------
// 3. CALCULAR PORCENTAJE Y COLOR
// ---------------------------------------------------------
var _porcentaje = clamp(sprint_actual / sprint_max, 0, 1);
var _ancho_relleno = _ancho_barra * _porcentaje;

// Colores pasivos según el estado
var _color_barra;
var _color_glow;

if (sprint_cooldown > 0) {
    // ESTADO: En Cooldown (Rojo apagado)
    _color_barra = make_color_rgb(105, 45, 45);
    _color_glow = make_color_rgb(125, 55, 55);
} 
else if (corriendo) {
    // ESTADO: Corriendo (Amarillo/Ámbar apagado)
    _color_barra = make_color_rgb(130, 110, 55);
    _color_glow = make_color_rgb(150, 130, 75);
} 
else {
    // ESTADO: Normal (Azul/Gris apagado)
    _color_barra = make_color_rgb(65, 85, 105);
    _color_glow = make_color_rgb(85, 105, 125);
}

// ---------------------------------------------------------
// 4. FONDO DEL PANEL (Minimalista)
// ---------------------------------------------------------
// Panel semi-transparente contenedor más compacto
draw_set_alpha(0.65);
draw_set_color(c_black);
draw_roundrect_ext(
    _x_pos - 6, 
    _y_pos - 22, 
    _x_pos + _ancho_barra + 6, 
    _y_pos + _alto_barra + 6, 
    3, 3, false
);
draw_set_alpha(1);

// Borde sutil del panel
draw_set_alpha(0.4);
draw_set_color(make_color_rgb(60, 60, 60));
draw_roundrect_ext(
    _x_pos - 6, 
    _y_pos - 22, 
    _x_pos + _ancho_barra + 6, 
    _y_pos + _alto_barra + 6, 
    3, 3, true
);
draw_set_alpha(1);

// ---------------------------------------------------------
// 5. TEXTO "STAMINA" ARRIBA (Sin Fuentes Personalizadas)
// ---------------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1); // FUENTE POR DEFECTO SIEMPRE

// Sombra
draw_set_color(c_black);
draw_text(_x_pos + 1, _y_pos - 17, "STAMINA");

// Texto principal (gris medio)
draw_set_color(make_color_rgb(130, 130, 130));
draw_text(_x_pos, _y_pos - 18, "STAMINA");

// Porcentaje a la derecha
var _porcentaje_texto = string(floor(_porcentaje * 100)) + "%";
draw_set_halign(fa_right);

draw_set_color(c_black);
draw_text(_x_pos + _ancho_barra + 1, _y_pos - 17, _porcentaje_texto);

draw_set_color(make_color_rgb(110, 110, 110));
draw_text(_x_pos + _ancho_barra, _y_pos - 18, _porcentaje_texto);

// ---------------------------------------------------------
// 6. FONDO DE LA BARRA (Base Oscura)
// ---------------------------------------------------------
draw_set_color(make_color_rgb(20, 22, 25));
draw_roundrect_ext(
    _x_pos, 
    _y_pos, 
    _x_pos + _ancho_barra, 
    _y_pos + _alto_barra, 
    2, 2, false
);

// ---------------------------------------------------------
// 7. DIBUJAR RELLENO DE LA BARRA CON EFECTOS
// ---------------------------------------------------------
if (_ancho_relleno > 2) {
    // Glow suave detrás (más sutil)
    draw_set_alpha(0.25);
    draw_set_color(_color_glow);
    draw_roundrect_ext(
        _x_pos + 1, 
        _y_pos, 
        _x_pos + _ancho_relleno, 
        _y_pos + _alto_barra, 
        2, 2, false
    );
    
    // Barra principal
    draw_set_alpha(1);
    draw_set_color(_color_barra);
    draw_roundrect_ext(
        _x_pos + 1, 
        _y_pos + 1, 
        _x_pos + _ancho_relleno - 1, 
        _y_pos + _alto_barra - 1, 
        2, 2, false
    );
    
    // Highlight superior muy sutil
    draw_set_alpha(0.15);
    draw_set_color(c_white);
    draw_rectangle(
        _x_pos + 2, 
        _y_pos + 2, 
        _x_pos + _ancho_relleno - 2, 
        _y_pos + (_alto_barra / 2.5),
        false
    );
    draw_set_alpha(1);
    
    // Segmentos visuales (divisiones sutiles)
    draw_set_alpha(0.12);
    draw_set_color(c_black);
    for (var i = 1; i < 4; i++) {
        var _seg_x = _x_pos + (_ancho_barra / 4) * i;
        if (_seg_x < _x_pos + _ancho_relleno - 5) {
            draw_line_width(_seg_x, _y_pos + 2, _seg_x, _y_pos + _alto_barra - 2, 1);
        }
    }
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// 8. BORDE DE LA BARRA (Contorno Definido)
// ---------------------------------------------------------
draw_set_color(make_color_rgb(45, 45, 45));
draw_roundrect_ext(
    _x_pos, 
    _y_pos, 
    _x_pos + _ancho_barra, 
    _y_pos + _alto_barra, 
    2, 2, true
);

// ---------------------------------------------------------
// 9. ANIMACIÓN DE ADVERTENCIA (Stamina Baja)
// ---------------------------------------------------------
if (_porcentaje < 0.3 && sprint_cooldown <= 0 && !corriendo) {
    var _pulse = (sin(current_time / 250) * 0.5) + 0.5; // Oscila entre 0 y 1
    draw_set_alpha(_pulse * 0.35);
    draw_set_color(make_color_rgb(150, 65, 65));
    draw_roundrect_ext(
        _x_pos - 1, 
        _y_pos - 1, 
        _x_pos + _ancho_barra + 1, 
        _y_pos + _alto_barra + 1, 
        3, 3, true
    );
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// 10. EFECTO DE DEPLECIÓN (Cuando está corriendo)
// ---------------------------------------------------------
if (corriendo && _ancho_relleno > 10) {
    // Partículas animadas saliendo del extremo
    var _particle_x = _x_pos + _ancho_relleno;
    var _offset = (current_time / 50) % 8;
    
    draw_set_alpha(0.4);
    draw_set_color(_color_glow);
    draw_circle(_particle_x - _offset, _y_pos + (_alto_barra / 2), 2, false);
    draw_circle(_particle_x - _offset - 4, _y_pos + 4, 1.5, false);
    draw_circle(_particle_x - _offset - 4, _y_pos + _alto_barra - 4, 1.5, false);
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// 11. ADVERTENCIA DE COOLDOWN (Más Elegante)
// ---------------------------------------------------------
if (sprint_cooldown > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(-1); // FUENTE POR DEFECTO
    
    var _alpha_warning = clamp(sprint_cooldown / 40, 0, 1);
    draw_set_alpha(_alpha_warning * 0.75);
    
    // Sombra del texto
    draw_set_color(c_black);
    draw_text(_x_pos + (_ancho_barra / 2) + 1, _y_pos + (_alto_barra / 2) + 1, "EXHAUSTED");
    
    // Texto principal
    draw_set_color(make_color_rgb(140, 60, 60));
    draw_text(_x_pos + (_ancho_barra / 2), _y_pos + (_alto_barra / 2), "EXHAUSTED");
    
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// 12. INDICADOR VISUAL EXTRA (Estado Normal Completo)
// ---------------------------------------------------------
if (_porcentaje >= 0.99 && !corriendo && sprint_cooldown <= 0) {
    // Pequeño brillo en el borde cuando está llena
    var _ready_pulse = (sin(current_time / 400) * 0.3) + 0.3;
    draw_set_alpha(_ready_pulse);
    draw_set_color(make_color_rgb(85, 105, 125));
    draw_roundrect_ext(
        _x_pos - 1, 
        _y_pos - 1, 
        _x_pos + _ancho_barra + 1, 
        _y_pos + _alto_barra + 1, 
        3, 3, true
    );
    draw_set_alpha(1);
}

// ---------------------------------------------------------
// RESETEAR PROPIEDADES DE DIBUJO
// ---------------------------------------------------------
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);