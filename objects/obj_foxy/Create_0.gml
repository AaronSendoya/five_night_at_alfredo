/// @description Configuración Foxy: Rastreador Alfa

// 1. IDENTIDAD
if (variable_global_exists("ai_level_rufus")) {
    my_ai_level = global.ai_level_rufus;
    my_boot_time = global.boot_rufus; 
} else {
    my_ai_level = 0;
    my_boot_time = 0;
}

event_inherited(); // Iniciar Grid y Listas

// 2. ESTADÍSTICAS DE VELOCIDAD (Foxy es el más rápido)
velocidad_normal = 3.5; 
velocidad_caza   = 6.3; // Aumentada para que sea casi imposible escapar a pie

move_speed  = velocidad_normal;
chase_speed = velocidad_caza;

// 3. MEMORIA DE CAZA (ESTILO FREDDY)
is_hunting_foxy = false;
hunt_timer_foxy = 0; 

// 4. POSICIÓN INICIAL
home_x = xstart;
home_y = ystart;
path_return = path_add();

// 5. SPRITES
spr_frente    = sp_foxy_caminar_frente;
spr_atras     = sp_foxy_caminar_atras;
spr_derecha   = sp_foxy_caminar_derecha;
spr_izquierda = sp_foxy_caminar_izquierda;

state = "IDLE";