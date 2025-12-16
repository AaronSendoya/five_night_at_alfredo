/// @description Dibujar Pantallas del Tutorial

if (tutorial_active) {
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    // Fondo negro semi-transparente
    draw_set_alpha(fade_alpha * 0.9);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _w, _h, false);
    draw_set_alpha(1);
    
    // ===================================================
    // DIBUJAR SPRITE (SI EXISTE PARA ESTE PASO)
    // ===================================================
    var _current_sprite = tutorial_sprites[tutorial_step];

    // CASO ESPECIAL: Paso 3 muestra fusible quemado Y bueno
    if (tutorial_step == 3) {
        draw_set_alpha(fade_alpha);
        
        // Fusible QUEMADO (izquierda)
        draw_sprite_ext(sp_fusible_0, 0, (_w / 2) - 100, (_h / 2) + sprite_y_offset, 2, 2, 0, c_white, fade_alpha);
        
        // Texto "QUEMADO"
        draw_set_halign(fa_center);
        draw_set_color(c_red);
        if (font_exists(fnt_tutorial)) {
            draw_set_font(fnt_tutorial);
        }
        draw_text((_w / 2) - 100, (_h / 2) + sprite_y_offset + 80, "QUEMADO");
        
        // Fusible BUENO (derecha)
        draw_sprite_ext(sp_fusible_1, 0, (_w / 2) + 100, (_h / 2) + sprite_y_offset, 2, 2, 0, c_white, fade_alpha);
        
        // Texto "FUNCIONAL"
        draw_set_color(c_lime);
        draw_text((_w / 2) + 100, (_h / 2) + sprite_y_offset + 80, "FUNCIONAL");
        
        draw_set_alpha(1);
    }
    // CASO NORMAL: Un solo sprite
    else if (_current_sprite != noone && sprite_exists(_current_sprite)) {
        draw_set_alpha(fade_alpha);
        
        // Calcular escala para que no sea muy grande
        var _sprite_w = sprite_get_width(_current_sprite);
        var _sprite_h = sprite_get_height(_current_sprite);
        var _max_size = 300; // Tamaño máximo del sprite
        var _scale = 1;
        
        // Si el sprite es muy grande, escalarlo
        if (_sprite_w > _max_size || _sprite_h > _max_size) {
            var _scale_w = _max_size / _sprite_w;
            var _scale_h = _max_size / _sprite_h;
            _scale = min(_scale_w, _scale_h);
        }
        
        // Dibujar el sprite centrado arriba
        draw_sprite_ext(
            _current_sprite, 
            0, 
            _w / 2, 
            (_h / 2) + sprite_y_offset, 
            _scale, 
            _scale, 
            0, 
            c_white, 
            fade_alpha
        );
        
        draw_set_alpha(1);
    }
    
    // ===================================================
    // DIBUJAR TEXTO DEBAJO DEL SPRITE
    // ===================================================
    draw_set_alpha(fade_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    // Usar fuente si existe
    if (font_exists(fnt_tutorial)) {
        draw_set_font(fnt_tutorial);
    }
    
    // Posición del texto (más abajo si hay sprite)
var _text_y = _h / 2;
if (_current_sprite != noone) {
    _text_y = (_h / 2) + 80; // Mover texto más abajo
}
    
    // Dibujar el texto actual
    draw_text(_w / 2, _text_y, tutorial_texts[tutorial_step]);
    
    // ===================================================
    // INDICADOR "PRESIONA ESPACIO"
    // ===================================================
    // Efecto de parpadeo
    var _blink = (sin(current_time / 300) * 0.5) + 0.5; // Oscila entre 0 y 1
    draw_set_alpha(fade_alpha * _blink * 0.7);
    draw_set_color(make_color_rgb(200, 200, 200));
    
    if (font_exists(fnt_tutorial)) {
        draw_set_font(fnt_tutorial);
    }
    
    draw_text(_w / 2, _h - 80, "[ PRESIONA ESPACIO ]");
    
    // ===================================================
    // INDICADOR DE PROGRESO (ESQUINA INFERIOR DERECHA)
    // ===================================================
    draw_set_alpha(fade_alpha);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(make_color_rgb(150, 150, 150));
    
    if (font_exists(fnt_tutorial)) {
        draw_set_font(fnt_tutorial);
    }
    
    draw_text(_w - 20, _h - 20, string(tutorial_step + 1) + " / " + string(total_steps));
    
    // ===================================================
    // RESETEAR PROPIEDADES DE DIBUJO
    // ===================================================
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}