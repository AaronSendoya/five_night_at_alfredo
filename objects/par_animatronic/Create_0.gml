/// @description Configuración COMPLETA + Sistema de Paciencia + Memoria Persistente

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
boot_timer_frames = my_boot_time * 60; 

if (is_active_by_level) {
    // ---------------------------------------------------------
    // 1. VELOCIDAD
    // ---------------------------------------------------------
    move_speed = 1.7 + (my_ai_level * 0.15);
    chase_speed = move_speed + 1.5; 
    
    // ---------------------------------------------------------
    // 2. PAUSA ENTRE PUNTOS (Patrullaje) - MÁS ÁGIL
    // ---------------------------------------------------------
    // Reducimos las pausas para que no se queden "congelados" tanto rato
    // Nivel 0:  Espera entre 0.5s y 1.2s
    // Nivel 20: Espera entre 0.1s y 0.4s
    patrol_wait_min = max(5,  30 - my_ai_level); 
    patrol_wait_max = max(20, 75 - (my_ai_level * 2.5)); 
    
    // ---------------------------------------------------------
    // 3. PACIENCIA EN LA SALA (DRÁSTICAMENTE REDUCIDA)
    // ---------------------------------------------------------
    // Fórmula: Base 360 (6 seg) - (Nivel * 15)
    
    // Nivel 0:  360 frames (6.0 segundos) -> Da tiempo a verlos, pero no aburren.
    // Nivel 10: 210 frames (3.5 segundos).
    // Nivel 20: 60 frames  (1.0 segundo) -> Entran, chequean y se van.
    
    // Usamos 'max' para que nunca sea instantáneo (mínimo 1 segundo)
    room_patience_max = max(60, 360 - (my_ai_level * 15)); 
    
    room_patience_timer = room_patience_max; 
} 
else {
    // Valores de inactividad
    move_speed = 0;
    chase_speed = 0;
    patrol_wait_min = 60;
    patrol_wait_max = 60;
    room_patience_timer = 999999; 
}

grid_cell_size = 32; 
path = path_add();   

// 3. Crear la Rejilla
var _hcells = room_width div grid_cell_size;
var _vcells = room_height div grid_cell_size;
grid_ia = mp_grid_create(0, 0, _hcells, _vcells, grid_cell_size, grid_cell_size);

mp_grid_add_instances(grid_ia, obj_pared, false);
mp_grid_add_instances(grid_ia, obj_pared_2, false); 

// 4. PUNTOS DE INTERÉS (WARPS)
interest_points = ds_list_create();
var _num = instance_number(obj_warp);
for (var i = 0; i < _num; i++) {
    ds_list_add(interest_points, instance_find(obj_warp, i));
}

// 5. MEMORIA DE NAVEGACIÓN (PERSISTENTE)
// Esta variable recordará de qué SALA vengo para no volver a entrar ahí.
last_room_visited = noone; 

// --- CORRECCIÓN 2: CARGAR MEMORIA DE LA NUBE ---
if (variable_global_exists("ubicaciones")) {
    var _mis_datos = global.ubicaciones[? object_index];
    
    // Si existen datos guardados y hay un registro de "last_room"
    if (!is_undefined(_mis_datos) && variable_struct_exists(_mis_datos, "last_room")) {
        // ¡RECUPERAMOS LA MEMORIA! "Ah, vengo de la Cocina".
        last_room_visited = _mis_datos.last_room;
    }
}

// 6. Estado Inicial
state = "IDLE"; 
alarm[0] = 60;  

// Variables de control de movimiento
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


// VARIABLES TEMPORALES PARA EL WARP (DELAY)
warp_target_room = noone;
warp_target_x = 0;
warp_target_y = 0;