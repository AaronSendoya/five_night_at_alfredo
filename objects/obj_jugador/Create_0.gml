/// @description Variables iniciales

// --- MOVIMIENTO ---
// Velocidad base que ya tenías
velocidad = 6.5;

// Velocidades derivadas
velocidad_walk = velocidad;          // caminar normal
velocidad_run  = velocidad * 1.8;    // correr un poco más rápido
velocidad_actual = velocidad_walk;   // la que usamos en el Step

// Iniciamos la animación quieta
image_speed = 0;

// --- SPRINT / BARRA DE CARRERA ---
sprint_max = 220;             // valor máximo de “energía de sprint”
sprint_actual = sprint_max;   // empieza lleno
sprint_gasto = 1.3;           // cuánto se gasta por step al correr
sprint_recuperacion = 0.7;    // cuánto se recupera por step cuando NO corre
sprint_cooldown_time = 120;    // frames de enfriamiento cuando se vacía (1 seg a 60fps)
sprint_cooldown = 0;          // contador de enfriamiento (0 = sin enfriamiento)
corriendo = false;            // flag para saber si está corriendo

// --- INTERACCIÓN (tecla E) ---
interact_range  = 32;         // radio máximo para detectar cosas
interact_target = noone;      // instancia objetivo actual
puede_interactuar = false;    // hay algo cerca con lo que se puede interactuar

// IMPORTANTE: para que sea limpio,
// luego crearemos un padre par_interactable
// y todos los objetos interactuables heredarán de él.

// ======================
// ESTADOS DEL JUGADOR
// ======================
/// Estados lógicos
PLAYER_STATE_NORMAL      = 0;
PLAYER_STATE_HIDDEN      = 1;
PLAYER_STATE_INTERACTING = 2;
PLAYER_STATE_CHASED      = 3;
PLAYER_STATE_DEAD        = 4;

// Estado inicial
player_state = PLAYER_STATE_NORMAL;

// Flags auxiliares
is_hidden      = false;
is_interacting = false;
is_chased      = false;

// Referencia al escondite actual (si está oculto)
hiding_spot = noone;

puede_moverse = true; // Interruptor maestro de movimiento

// --- SISTEMA DE TELETRANSPORTE (Fix para volver del Arcade) ---

// Verificamos si hay coordenadas pendientes esperando
if (variable_global_exists("jugador_return_x") && global.jugador_return_x != -1) {
    
    // Teletransportar al jugador a las coordenadas guardadas
    x = global.jugador_return_x;
    y = global.jugador_return_y;
    
    // Borrar las coordenadas para que no se teletransporte de nuevo por error
    global.jugador_return_x = -1;
    global.jugador_return_y = -1;
}

// =========================================================
// SISTEMA DE TELETRANSPORTE (Recepción)
// =========================================================

// Preguntamos: "¿Hay coordenadas guardadas esperando por mí?"
if (variable_global_exists("jugador_return_x") && global.jugador_return_x != -1) {
    
    // ¡Sí hay! Me muevo ahí inmediatamente
    x = global.jugador_return_x;
    y = global.jugador_return_y;
    
    // Debug: Mensaje para confirmar que funcionó
    show_debug_message("TELETRANSPORTE ÉXITOSO a: " + string(x) + ", " + string(y));
    
    // Borramos las coordenadas para que no se repita el viaje por error
    global.jugador_return_x = -1;
    global.jugador_return_y = -1;
}

// Si estamos en tutorial, bloquear movimiento
if (instance_exists(o_game_controller)) {
    if (o_game_controller.visual_state == "TUTORIAL") {
        puede_moverse = false;
    }
}

