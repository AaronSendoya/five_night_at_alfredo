/// @description Reloj 
// Configuración de texto
draw_set_font(fnt_pixel); // Asegúrate de tener una fuente creada
draw_set_halign(fa_right);
draw_set_color(c_white);

// Formatear texto: Agregar un '0' si los minutos son menores a 10 (ej. 12:05)
var _min_str = string(current_minute_display);
if (current_minute_display < 10) _min_str = "0" + _min_str;

var _clock_str = string(current_hour_display) + ":" + _min_str + " AM";

// Dibujar en la esquina (ajusta coordenadas a tu gusto)
draw_text(display_get_gui_width() - 20, 20, _clock_str);

// Opcional: Mostrar la noche actual debajo
draw_set_font(fnt_pixel_small);
draw_text(display_get_gui_width() - 20, 50, "Night " + string(global.current_night));


