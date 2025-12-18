/// @description Dibujar la tecla flotante SIEMPRE

// Solo dibujamos si NO estamos dentro de las cámaras
if (!global.en_camaras) {
    
    // 1. Calcular el efecto de "Flotar" (Seno)
    var _flotar_y = sin(current_time / 200) * 5;
    
    // 2. Dibujar el sprite
    // Al no haber "if place_meeting", esto se dibuja siempre que estés en la sala
    draw_sprite_ext(
        sp_tecla_e,   // Tu sprite de la tecla
        0,             
        x + 16,        // Ajusta esto si no queda centrado
        y - 40 + _flotar_y, 
        6, 6,          
        0,             
        c_white,       
        1              
    );
}

draw_self();

if (mostrar_mensaje) {
    draw_set_halign(fa_center);
    
    if (global.power_on) {
        draw_set_color(c_white);
        draw_text(x, y - 50, "[E] CÁMARAS");
    } else {
        draw_set_color(c_red);
        draw_text(x, y - 50, "SIN ENERGÍA");
    }
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}