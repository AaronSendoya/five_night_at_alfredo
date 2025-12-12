/// @description Create de o_game_controller

// --- DEBUG GLOBAL ---
// true = muestra info de IA (rangos, estados) en par_animatronic
// false = para builds “finales”
global.debug_mode = true;

// --- SISTEMA DE TIEMPO ---
global.current_night = 1; // Noche actual (puedes cambiarlo al cargar partida)
game_timer = 0;           // Temporizador interno (en segundos)
seconds_per_hour = 90;    // 1 hora de juego = 90 segundos reales
start_hour = 12;          // 12 AM
end_hour = 6;             // 6 AM (Hora de ganar)

// Variables de estado
current_hour_display   = 12; // La hora que ve el jugador
current_minute_display = 0;
game_ended             = false; // Para evitar que el código siga corriendo al ganar
boot_sequence_done     = false; // Para el inicio inactivo

// Control Global de IA
global.animatronics_active = false; // Empiezan apagados
global.active_chases       = 0;     // Tickets del Director usados
global.max_chases          = 1;     // Límite base (se sobrescribe por noche)

night_settings = {
    n1: {
        ai_alfredo: 0,   // dificultad de Alfredo
        ai_matilda: 0,
        ai_bongo:  10,
        ai_rufus:  0,
        max_chases: 1,
        boot_time:  3   // segundos antes de que se active la IA
    },
    n2: {
        ai_alfredo: 5,
        ai_matilda: 4,
        ai_bongo:  5,
        ai_rufus:  5,
        max_chases: 1,
        boot_time:  100
    },
    n3: {
        ai_alfredo: 8,
        ai_matilda: 8,
        ai_bongo:  8,
        ai_rufus:  8,
        max_chases: 2,
        boot_time:  70
    }
};

// --- FUNCIÓN PARA CARGAR LA NOCHE ---
function apply_night_difficulty(_night) {
    // Clave dinámica tipo "n1", "n2", "n3"
    var _key  = "n" + string(_night);
    var _data = night_settings[$ _key];

    // Si no existe (ej. Noche 7), usa una configuración por defecto o error
    if (is_undefined(_data)) {
        show_debug_message("Error: Datos de noche " + _key + " no encontrados");
        return;
    }

    // Aplica las variables a las globales de IA
    global.ai_level_alfredo = _data.ai_alfredo;
    global.ai_level_matilda = _data.ai_matilda;
    global.ai_level_bongo   = _data.ai_bongo;
    global.ai_level_rufus   = _data.ai_rufus;
    global.max_chases       = _data.max_chases;

    // Configura alarma de inicio (boot_time está en segundos)
    alarm[0] = _data.boot_time * room_speed;

    show_debug_message("Noche " + string(_night) + " cargada. Dificultad aplicada.");
}

// Iniciar la noche inmediatamente
apply_night_difficulty(global.current_night);
