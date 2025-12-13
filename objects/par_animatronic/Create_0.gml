/// @description Configuración COMPLETA

// 1. Sprites (Definir en los hijos)
spr_frente = noone;
spr_atras = noone;
spr_derecha = noone;
spr_izquierda = noone;

// 2. Variables de Movimiento e IA
move_speed = 1.9;    // Velocidad de Patrulla
chase_speed = 4.0;   // Velocidad de Persecución
grid_cell_size = 32; 

path = path_add();   

// 3. Crear la Rejilla (El cerebro)
var _hcells = room_width div grid_cell_size;
var _vcells = room_height div grid_cell_size;

grid_ia = mp_grid_create(0, 0, _hcells, _vcells, grid_cell_size, grid_cell_size);

// Añadimos las paredes OPACAS (Bloquean paso Y visión)
mp_grid_add_instances(grid_ia, obj_pared, false);

// --- NUEVO ---
// Añadimos las paredes TRANSPARENTES (Bloquean paso PERO NO visión)
// Asegúrate de que obj_pared_2 existe en tu proyecto
mp_grid_add_instances(grid_ia, obj_pared_2, false); 

// 4. PUNTOS DE INTERÉS
interest_points = ds_list_create();

// Buscar todos los Warps y guardarlos en la lista
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