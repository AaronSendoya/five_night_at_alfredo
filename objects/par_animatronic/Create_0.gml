/// @description Configuración COMPLETA + Dificultad + Auto-Registro

// 1. Sprites (Definir en los hijos)
spr_frente = noone;
spr_atras = noone;
spr_derecha = noone;
spr_izquierda = noone;

// 2. CÁLCULO DE DIFICULTAD Y ESTADÍSTICAS
if (!variable_instance_exists(id, "my_ai_level")) my_ai_level = 0;
if (!variable_instance_exists(id, "my_boot_time")) my_boot_time = 0;

// INTERRUPTOR DE NIVEL
is_active_by_level = (my_ai_level > 0);

// TEMPORIZADOR DE INICIO (BOOT TIMER)
// Convertimos segundos a frames (60 frames = 1 segundo aprox)
boot_timer_frames = my_boot_time * 60; 

if (is_active_by_level) {
    // FÓRMULA DE VELOCIDAD (0-20):
    move_speed = 1.5 + (my_ai_level * 0.15);
    chase_speed = move_speed + 1.5; 
    
    // TIEMPO DE ESPERA (Patrulla):
    patrol_wait_min = max(15, 90 - (my_ai_level * 3));
    patrol_wait_max = max(30, 150 - (my_ai_level * 5));
} 
else {
    move_speed = 0;
    chase_speed = 0;
    patrol_wait_min = 60;
    patrol_wait_max = 60;
}

grid_cell_size = 32; 
path = path_add();   

// 3. Crear la Rejilla
var _hcells = room_width div grid_cell_size;
var _vcells = room_height div grid_cell_size;
grid_ia = mp_grid_create(0, 0, _hcells, _vcells, grid_cell_size, grid_cell_size);

mp_grid_add_instances(grid_ia, obj_pared, false);
mp_grid_add_instances(grid_ia, obj_pared_2, false); 

// 4. PUNTOS DE INTERÉS
interest_points = ds_list_create();
var _num = instance_number(obj_warp);
for (var i = 0; i < _num; i++) {
    ds_list_add(interest_points, instance_find(obj_warp, i));
}

// 5. Estado Inicial
state = "IDLE"; 
alarm[0] = 60;  

// Variables de control
xp = x;
yp = y;
stuck_timer = 0;

// =========================================================
// SISTEMA DE AUTO-REGISTRO
// =========================================================
if (instance_exists(obj_director_ia) && variable_global_exists("ubicaciones")) {
    if (!ds_map_exists(global.ubicaciones, object_index)) {
        registrar_viaje(object_index, room, x, y);
    }
    else {
        var _datos = global.ubicaciones[? object_index];
        if (_datos.sala != room) {
            instance_destroy();
            exit; 
        }
    }
}