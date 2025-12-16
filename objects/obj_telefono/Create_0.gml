/// @description Configuración del teléfono

// Estado del teléfono
esta_sonando = false;
tiempo_hasta_sonar = 120; 
ya_sono_alguna_vez = false; 

// Animación de vibración
shake_x = 0;
shake_y = 0;
shake_intensity = 2;

// Posición original
original_x = x;
original_y = y;

// Control de sonido
sonido_actual = noone;
sonido_voz = noone; 

// Interacción
puede_interactuar = false;