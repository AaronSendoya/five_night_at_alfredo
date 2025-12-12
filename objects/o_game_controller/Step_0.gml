// Si el juego ya terminó, no hacemos nada
if (game_ended) exit;

// 1. AUMENTAR EL TIEMPO
// delta_time nos da el tiempo en microsegundos desde el último frame.
// Dividir por 1.000.000 lo convierte a segundos.
// Esto hace que el reloj sea preciso aunque el juego tenga lag.
game_timer += delta_time / 1000000;

// 2. CALCULAR HORA Y MINUTOS
// Total de horas pasadas desde el inicio
var _hours_passed = floor(game_timer / seconds_per_hour);

// Calculamos la hora actual (12 + horas pasadas)
// El truco del % 12 es para formato 12h, pero simple:
var _raw_hour = start_hour + _hours_passed;
if (_raw_hour > 12) _raw_hour -= 12; // Convertir 13 a 1, 14 a 2, etc.
current_hour_display = _raw_hour;

// Calculamos minutos (regla de tres simple)
// Porcentaje de la hora actual * 60 minutos
var _seconds_into_hour = game_timer % seconds_per_hour;
current_minute_display = floor((_seconds_into_hour / seconds_per_hour) * 60);

// 3. CHEQUEO DE VICTORIA (6 AM)
// Si han pasado 6 horas completas (6 * 90s = 540s)
if (_hours_passed >= (end_hour)) { // Nota: asumiendo que start es 12 y queremos llegar a 6 horas después
    game_ended = true;
    current_hour_display = 6;
    current_minute_display = 0;
    
    // APAGADO DE EMERGENCIA (SHUTDOWN)
    global.animatronics_active = false;
    
    // Lógica de ganar
    show_debug_message("¡6:00 AM! Noche completada.");
    // room_goto(rm_win_screen); o instance_create_layer(..., o_win_sequence);
}/// @description Insert description here
// You can write your code in this editor


