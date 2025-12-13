/// @description USAR WARP (RÁPIDO)

// Detener movimiento
path_end();

// Teletransportar
x = other.target_x;
y = other.target_y;

// Resetear estado
state = "IDLE";

// CAMBIO: Esperar solo 15 frames (0.25 seg) en la nueva sala antes de moverse
// Antes era 60. Esto hace que cruce la puerta y siga caminando fluido.
alarm[0] = 15;