/// @description Configuración y Dirección de Salida
image_speed = 0;
interaction_radius = 64; 
mostrar_mensaje = false; 
flotar_angulo = 0;       

// --- SISTEMA DE SALIDA SEGURA (OFFSET MEJORADO) ---
exit_angle = 270;   // 270=Abajo, 180=Izq, 0=Der, 90=Arriba
exit_distance = 150; // AUMENTADO A 70px para garantizar que salga de la pared

// Variables de Tiempo y Cooldown (10 Segundos = 600 frames)
hide_time_max = 240;
hide_time_current = 600;
hide_cooldown_max = 560;
hide_cooldown = 0;

// --- NUEVO: TIEMPO DE ENTRADA (DELAY DE 1 SEGUNDO) ---
entry_timer = 0;
entry_max = 60; // 60 frames = 1 segundo

