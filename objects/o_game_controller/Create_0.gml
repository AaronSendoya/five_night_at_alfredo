/// @description Configuración Global, IA, Visuales y Sistema de Memoria

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

// --- SISTEMA DE INVENTARIO (FUSIBLES) ---
global.has_fuse = false; 
global.equipped_item = 0; // 0=Linterna, 1=Taser
global.has_taser = false; 

// Variable de invisibilidad
global.player_hidden = false;
// Control del teléfono (solo suena una vez)
global.telefono_ya_sono = false;

// --- NUEVO: SISTEMA ELÉCTRICO (DIFICULTAD) ---
global.fuse_interval = 120; 
global.fuse_chance   = 0;   
global.start_broken  = 0;   
fuse_system_timer    = 0;   

amb_started = false; 
// --- SPAWNER DE ITEMS ---
fuse_spawn_timer = 0; 


// Instanciar controladores auxiliares
if (!instance_exists(obj_light_controller)) {
    instance_create_depth(0, 0, 0, obj_light_controller);
}

// --- SISTEMA DE VIDAS ---
if (!variable_global_exists("player_lives")) {
    global.player_lives = 3; 
}

// =========================================================
// 2. CONFIGURACIÓN DEL SISTEMA DE JUEGO
// =========================================================

global.debug_mode = true;

if (!variable_global_exists("current_night")) {
    global.current_night = 1; 
}

// Inicializar variable de config vacía para evitar errores antes de cargar
global.night_config = -1; 

// Variables base
game_timer = 0;             
seconds_per_hour = 70;      
start_hour = 12;            
end_hour = 6;               

current_hour_display    = 12; 
current_minute_display = 0;
game_ended              = false; 
boot_sequence_done      = false; 

// =========================================================
// VERIFICAR SI ESTAMOS EN EL MENÚ PRINCIPAL
// =========================================================
if (room == rm_menu_principal) {
    instance_destroy();
    exit;
}

// Valores por defecto
visual_state = "TUTORIAL"; 
intro_timer = 180;
outro_timer = 300; 

// =========================================================
// 3. INTEGRACIÓN: LÓGICA DE MEMORIA
// =========================================================
if (variable_global_exists("skip_intro") && global.skip_intro == true) {
    // --- CASO A: REGRESO DEL ARCADE ---
    if (variable_global_exists("saved_game_timer")) {
        game_timer = global.saved_game_timer;
    }
    
    visual_state = "GAME";
    intro_timer = 0;
    
    global.animatronics_active = true; 
    boot_sequence_done = true;
    global.skip_intro = false;
    
    show_debug_message("MEMORIA RESTAURADA: Hora recuperada.");

} else {
    // --- CASO B: INICIO NORMAL ---
    global.animatronics_active = false;
    
    if (global.current_night == 1) {
        visual_state = "TUTORIAL";
        if (!instance_exists(obj_tutorial_controller)) {
            instance_create_depth(0, 0, -10000, obj_tutorial_controller);
        }
    } else {
        visual_state = "INTRO";
    }
}

// =========================================================
// 4. CONFETI Y EFECTOS
// =========================================================
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
// 5. CONFIGURACIÓN DE NOCHES
// =========================================================
night_settings = {
    n1: {
        fuse_spawn_seconds: 10, // <--- ESTO ES LO QUE QUEREMOS LEER
        ai_alfredo: 0, 
        ai_matilda: 10, 
        ai_bongo: 10, 
        ai_rufus: 10,
        max_chases: 2,
        boot_time_alfredo: 0,
        boot_time_matilda: 120,
        boot_time_bongo: 100, 
        boot_time_rufus: 0,
        fuse_burn_interval: 70,    
        fuse_burn_chance: 40,      
        start_broken_fuses: 0      
    },
    n2: {
        fuse_spawn_seconds: 50,
        ai_alfredo: 15, 
        ai_matilda: 15, 
        ai_bongo: 15, 
        ai_rufus: 15,
        max_chases: 3,
        boot_time_alfredo: 100,
        boot_time_matilda: 80,
        boot_time_bongo: 70,
        boot_time_rufus: 0,
        fuse_burn_interval: 50,  
        fuse_burn_chance: 45,    
        start_broken_fuses: 0    
    },
    n3: {
        fuse_spawn_seconds: 55,
        ai_alfredo: 20, 
        ai_matilda: 20, 
        ai_bongo: 20, 
        ai_rufus: 20,
        max_chases: 4,
        boot_time_alfredo: 80,
        boot_time_matilda: 40,
        boot_time_bongo: 30,
        boot_time_rufus: 0,
        fuse_burn_interval: 40,  
        fuse_burn_chance: 50,    
        start_broken_fuses: 2    
    }
};

// --- FUNCIÓN PARA CARGAR LA NOCHE ---
function apply_night_difficulty(_night) {
    var _key  = "n" + string(_night);
    
    if (!variable_struct_exists(night_settings, _key)) {
        show_debug_message("¡JUEGO TERMINADO! No hay más noches configuradas.");
        return;
    }

    // Obtenemos los datos de ESTA noche específica
    var _data = night_settings[$ _key];

    // =============================================================
    // ¡¡¡AQUÍ ESTÁ LA CORRECCIÓN!!!
    // Guardamos la configuración de ESTA noche en la variable GLOBAL
    // para que el Step Event pueda leer "fuse_spawn_seconds"
    // =============================================================
    global.night_config = _data; 

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
    
    // --- CARGAR ELECTRICIDAD ---
    global.fuse_interval = _data.fuse_burn_interval;
    global.fuse_chance   = _data.fuse_burn_chance;
    global.start_broken  = _data.start_broken_fuses;
    
    fuse_system_timer = 0;

    if (!global.animatronics_active) {
        alarm[0] = -1; 
    }
    
    show_debug_message("Noche cargada: " + string(_night));
}

apply_night_difficulty(global.current_night);

// Base de datos de Items (Struct Global)
global.item_db = {
    "fusible": {
        nombre: "Fusible Industrial",
        descripcion: "Componente esencial.",
        sprite: sp_fusible_1, 
        max_stack: 2,     
        limit_total: 2   
    },
    "bateria": {
        nombre: "Batería 9V",
        descripcion: "Energía extra.",
        sprite: sp_fusible_1, 
        max_stack: 5,
    }
};

if (!instance_exists(obj_inventario)) {
    instance_create_depth(0, 0, -10000, obj_inventario);
}