/// @description Configuración y Variables
image_speed = 0;
interaction_radius = 64;

// Variables visuales
mostrar_mensaje = false;
flotar_angulo = 0;

// Estado
escondido_aqui = false;

// Memoria de posición
saved_x = 0;
saved_y = 0;

// --- SISTEMA DE TIEMPO Y COOLDOWN (10 Segundos = 600 frames) ---
hide_time_max = 600;       
hide_time_current = 600;   
hide_cooldown_max = 600;   
hide_cooldown = 0;