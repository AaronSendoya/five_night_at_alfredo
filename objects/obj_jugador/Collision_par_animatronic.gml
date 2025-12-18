/// @description Muerte Jugador (Check de Actividad)

// 1. OBTENER AL ENEMIGO
// Usamos 'other' para referirnos al animatrónico específico que estamos tocando
var _enemigo = other;

// 2. CHECK DE SEGURIDAD (¿ESTÁ DORMIDO?)
// Si el animatrónico aún se está iniciando (booting) o la IA global está apagada...
if (_enemigo.boot_timer_frames > 0 || !global.animatronics_active) {
    exit; 
}

// 3. LÓGICA DE MUERTE (Solo si está despierto)
if (player_state != PLAYER_STATE_HIDDEN && player_state != PLAYER_STATE_DEAD) {
    player_state = PLAYER_STATE_DEAD;
    velocidad_actual = 0;
    image_speed = 0;
    
    // Detener sonidos si es necesario
    audio_stop_all(); 
    
    instance_create_depth(0, 0, -10000, obj_jumpscare);
}