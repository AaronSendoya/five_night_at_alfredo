if (mostrar_mensaje && !global.en_camaras) {
    
    // 1. Le decimos que use la fuente grande que creaste
    draw_set_font(fnt_aviso); 
    
    draw_set_halign(fa_center);
    draw_text(display_get_gui_width()/2, display_get_gui_height() - 100, "Presiona [E] para Camaras");
    draw_set_halign(fa_left);
    
    // 2. IMPORTANTE: Volver a la fuente normal (o -1 para default)
    // para no afectar otros textos del juego
    draw_set_font(-1); 
}