/// @description Configuración: GPS, Paredes y Dificultad Global

// 1. CARGAR IA Y BOOT TIME DEL CONTROLLER
if (variable_global_exists("ai_level_matilda")) {
    my_ai_level  = global.ai_level_matilda;
    my_boot_time = global.boot_matilda; 
} else {
    // Valores de seguridad por si el controller no cargó
    my_ai_level  = 10;
    my_boot_time = 0;
}

// 2. INICIALIZAR VARIABLES DE MISIÓN
path_mission = path_add();
path_set_kind(path_mission, 1); 
path_set_precision(path_mission, 8);
velocidad_mision = 3.5;

target_x_fixed = 5120;
target_y_fixed = 2160;

estado_actual = "NORMAL"; 
sabotage_panel_id = noone;

// 3. SINCRONIZACIÓN DE TIEMPOS (¡LA CLAVE DEL ARREGLO!)
// Si el tiempo de encendido es largo (ej: 50s), el sabotaje no puede ocurrir a los 10s.
// Hacemos que el primer sabotaje ocurra: Boot Time + 10 segundos.
var _primer_sabotaje = 600; // 10 segundos base
if (my_boot_time > 0) {
    // Convertimos boot_time (frames) y le sumamos el delay
    _primer_sabotaje += my_boot_time; 
}

timer_cooldown_max = 900; // 15 segundos entre intentos posteriores
timer_cooldown     = _primer_sabotaje; 
timer_romper_max   = 120; 
timer_romper       = 0;

// 4. INICIALIZAR PADRE (Esto configura la Grid)
event_inherited(); 

// 5. ASIGNACIÓN DE SPRITES
spr_frente    = sp_chica_caminar_frente;
spr_atras     = sp_chica_caminar_atras;
spr_derecha   = sp_chica_caminar_derecha;
spr_izquierda = sp_chica_caminar_izquierda;

// 6. CALIBRACIÓN DE OBSTÁCULOS
if (variable_instance_exists(id, "grid_ia")) {
    mp_grid_add_instances(grid_ia, obj_pared, false);
    mp_grid_add_instances(grid_ia, obj_pared_2, false); 
    // Asegúrate de que obj_warp NO se agregue aquí nunca.
}