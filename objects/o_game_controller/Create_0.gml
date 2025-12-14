/// @description Create de o_game_controller

// =========================================================
// 1. VARIABLES GLOBALES DE IA (DEFINICIÓN TEMPRANA)
// =========================================================
global.ai_level_alfredo = 0;
global.ai_level_matilda = 0;
global.ai_level_bongo   = 0; 
global.ai_level_rufus   = 0;

// NUEVO: Tiempos de espera individuales (en segundos)
global.boot_alfredo = 0;
global.boot_matilda = 0;
global.boot_bongo   = 0;
global.boot_rufus   = 0;

global.animatronics_active = false; // El interruptor maestro
global.active_chases        = 0;
global.max_chases           = 1;

// =========================================================
// 2. CONFIGURACIÓN DEL JUEGO
// =========================================================

// --- DEBUG GLOBAL ---
global.debug_mode = true;

// --- SISTEMA DE TIEMPO ---
global.current_night = 1; 
game_timer = 0;            
seconds_per_hour = 90;    
start_hour = 12;          
end_hour = 6;             

// Variables de estado
current_hour_display    = 12; 
current_minute_display = 0;
game_ended              = false; 
boot_sequence_done      = false; 

// CONFIGURACIÓN DE NOCHES (Corregido con comas)
night_settings = {
    n1: {
        ai_alfredo: 0,
        ai_matilda: 0, 
        ai_bongo:   10,
        ai_rufus:   0,
        max_chases: 1,
        // Tiempos de espera (segundos antes de salir)
        boot_time_alfredo: 0,
        boot_time_matilda: 90,
        boot_time_bongo:   20, // Ejemplo: Bongo espera 10s en Noche 1
        boot_time_rufus:   0
    },
    n2: {
        ai_alfredo: 10,
        ai_matilda: 15,
        ai_bongo:   15,
        ai_rufus:   10,
        max_chases: 1,
        boot_time_alfredo: 50,
        boot_time_matilda: 50,
        boot_time_bongo:   50,
        boot_time_rufus:   50
    },
    n3: {
        ai_alfredo: 20,
        ai_matilda: 20,
        ai_bongo:   20,
        ai_rufus:   15,
        max_chases: 2,
        boot_time_alfredo: 30,
        boot_time_matilda: 30,
        boot_time_bongo:   30,
        boot_time_rufus:   30
    }
};

// --- FUNCIÓN PARA CARGAR LA NOCHE ---
function apply_night_difficulty(_night) {
    var _key  = "n" + string(_night);
    var _data = night_settings[$ _key];

    if (is_undefined(_data)) {
        show_debug_message("Error: Datos de noche " + _key + " no encontrados");
        return;
    }

    // 1. Aplicar Niveles de IA
    global.ai_level_alfredo = _data.ai_alfredo;
    global.ai_level_matilda = _data.ai_matilda;
    global.ai_level_bongo   = _data.ai_bongo;
    global.ai_level_rufus   = _data.ai_rufus;
    global.max_chases       = _data.max_chases;
    
    // 2. Aplicar Tiempos de Espera (Boot Times)
    global.boot_alfredo = _data.boot_time_alfredo;
    global.boot_matilda = _data.boot_time_matilda;
    global.boot_bongo   = _data.boot_time_bongo;
    global.boot_rufus   = _data.boot_time_rufus;

    // Alarma para activar el flag global (Opcional, ahora dependen más de su timer individual)
    // Dejamos un delay mínimo de 1 segundo para la intro
    alarm[0] = 60; 

    show_debug_message("Noche " + string(_night) + " cargada. Dificultad aplicada.");
}

// Iniciar la noche inmediatamente
apply_night_difficulty(global.current_night);