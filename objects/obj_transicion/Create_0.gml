/// @description Configuración inicial

// Variables de destino (Ya no necesitamos target_room)
target_x = 0;
target_y = 0;
target_sprite = -1;

// Variables del efecto
alpha = 0; 
estado = "saliendo"; 
velocidad_efecto = 0.05;
// Al nacer la transición, bloqueamos al jugador inmediatamente
obj_jugador.puede_moverse = false;