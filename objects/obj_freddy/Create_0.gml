/// @description Configuración: El Cerebro (Freddy)

// 1. CONECTAR CON NIGHT SETTINGS
if (variable_global_exists("ai_level_alfredo")) {
    my_ai_level  = global.ai_level_alfredo;
    my_boot_time = global.boot_alfredo; 
} else {
    my_ai_level  = 0;
    my_boot_time = 0;
}

// 2. SEGURIDAD
can_see_player = false; 

// 3. INICIALIZAR PADRE
event_inherited(); 

// 4. SPRITES
spr_frente    = sp_freddy_caminar_frente;
spr_atras     = sp_freddy_caminar_atras;
spr_derecha   = sp_freddy_caminar_derecha;
spr_izquierda = sp_freddy_caminar_izquierda;

// 5. ESTADÍSTICAS Y MECÁNICA "RUSH"
speed_stalk = 2.5; 
speed_rush  = 5.0; 

move_speed  = speed_stalk; 
chase_speed = speed_stalk; 

// --- TEMPORIZADORES CORREGIDOS ---

// Intervalo: 30 segundos aprox (1800 frames)
// Rango entre 25 y 35 segundos para que no sea robótico
timer_attack_cooldown_max = irandom_range(1200, 1800); 
timer_attack_cooldown     = timer_attack_cooldown_max;

// Duración del Ataque/Sonido: 6 Segundos exactos (360 frames)
timer_rush_duration_max   = 540; 
timer_rush_duration       = 0;

is_rushing = false;

// 6. VISIÓN
view_dist = 650; 
fov_angle = 90; 

if (variable_instance_exists(id, "grid_ia")) {
    mp_grid_add_instances(grid_ia, obj_pared, false);
    mp_grid_add_instances(grid_ia, obj_pared_2, false); 
}