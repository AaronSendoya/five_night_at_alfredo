/// @description Configuración Global, IA y Visuales

// =========================================================
// 1. VARIABLES GLOBALES (IA Y TIEMPOS)
// =========================================================
global.ai_level_alfredo = 0;
global.ai_level_matilda = 0;
global.ai_level_bongo   = 0; 
global.ai_level_rufus   = 0;

global.boot_alfredo = 0;
global.boot_matilda = 0;
global.boot_bongo   = 0;
global.boot_rufus   = 0;

global.animatronics_active = false; 
global.active_chases        = 0;
global.max_chases           = 1;

// =========================================================
// 2. CONFIGURACIÓN VISUAL
// =========================================================

visual_state = "INTRO"; 

// INTRO: 3 segundos (180 frames a 60fps)
intro_timer = 180; 

// OUTRO: Tiempo que dura la celebración antes de pasar de nivel (5 seg)
outro_timer = 300; 

// CONFETI: Crear sistema de partículas manual
confetti_count = 100;
confetti_particles = array_create(confetti_count);

for (var i = 0; i < confetti_count; i++) {
    confetti_particles[i] = {
        x : irandom(display_get_gui_width()),
        y : irandom_range(-300, -10),
        spd : irandom_range(3, 6),
        col : choose(c_red, c_lime, c_yellow, c_aqua, c_fuchsia, c_white)
    };
}

// =========================================================
// 3. SISTEMA DE JUEGO
// =========================================================

global.debug_mode = true;

// --- PROTECCIÓN DE NIVEL ---
// Si la variable no existe (primera vez), la creamos en 1.
// Si ya existe (porque reiniciaste la sala para la noche 2), NO la tocamos.
if (!variable_global_exists("current_night")) {
    global.current_night = 1; 
}

game_timer = 0;            
seconds_per_hour =60;    
start_hour = 12;          
end_hour = 6;             

current_hour_display    = 12; 
current_minute_display = 0;
game_ended              = false; 
boot_sequence_done      = false; 

// --- CONFIGURACIÓN DE NOCHES ---
night_settings = {
    n1: {
        ai_alfredo: 0, 
        ai_matilda: 0, 
        ai_bongo: 10, 
        ai_rufus: 0,
        max_chases: 1,
        // Tiempos de espera (Boot Times) - 
        boot_time_alfredo: 0,
        boot_time_matilda: 90,
        boot_time_bongo: 30, 
        boot_time_rufus: 0
    },
    n2: {
        ai_alfredo: 10, 
        ai_matilda: 15, 
        ai_bongo: 15, 
        ai_rufus: 10,
        max_chases: 1,
        boot_time_alfredo: 50,
        boot_time_matilda: 50,
        boot_time_bongo: 50,
        boot_time_rufus: 50
    },
    n3: {
        ai_alfredo: 20, 
        ai_matilda: 20, 
        ai_bongo: 20, 
        ai_rufus: 15,
        max_chases: 2,
        boot_time_alfredo: 30,
        boot_time_matilda: 30,
        boot_time_bongo: 30,
        boot_time_rufus: 30
    }
};

// --- FUNCIÓN PARA CARGAR LA NOCHE ---
function apply_night_difficulty(_night) {
    var _key  = "n" + string(_night);
    
    // Verificamos si existe la configuración para esta noche
    if (!variable_struct_exists(night_settings, _key)) {
        show_debug_message("¡JUEGO TERMINADO! No hay más noches configuradas.");
        // Opcional: room_goto(rm_menu);
        return;
    }

    var _data = night_settings[$ _key];

    // Cargar IA
    global.ai_level_alfredo = _data.ai_alfredo;
    global.ai_level_matilda = _data.ai_matilda;
    global.ai_level_bongo   = _data.ai_bongo;
    global.ai_level_rufus   = _data.ai_rufus;
    global.max_chases       = _data.max_chases;
    
    // Cargar Boot Times
    global.boot_alfredo = _data.boot_time_alfredo;
    global.boot_matilda = _data.boot_time_matilda;
    global.boot_bongo   = _data.boot_time_bongo;
    global.boot_rufus   = _data.boot_time_rufus;

    // Desactivamos la alarma 0 porque ahora usamos la intro visual
    alarm[0] = -1; 
    
    show_debug_message("Noche cargada correctamente: " + string(_night));
}

// Iniciar configuración con la noche actual (sea 1, 2, 3...)
apply_night_difficulty(global.current_night);