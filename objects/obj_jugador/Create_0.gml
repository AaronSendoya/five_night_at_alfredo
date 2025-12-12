/// @description Variables iniciales

// --- MOVIMIENTO ---
// Velocidad base que ya tenías
velocidad = 7;

// Velocidades derivadas
velocidad_walk = velocidad;          // caminar normal
velocidad_run  = velocidad * 1.8;    // correr un poco más rápido
velocidad_actual = velocidad_walk;   // la que usamos en el Step

// Iniciamos la animación quieta
image_speed = 0;

// --- SPRINT / BARRA DE CARRERA ---
sprint_max = 200;             // valor máximo de “energía de sprint”
sprint_actual = sprint_max;   // empieza lleno
sprint_gasto = 1.3;           // cuánto se gasta por step al correr
sprint_recuperacion = 0.9;    // cuánto se recupera por step cuando NO corre
sprint_cooldown_time = 60;    // frames de enfriamiento cuando se vacía (1 seg a 60fps)
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
