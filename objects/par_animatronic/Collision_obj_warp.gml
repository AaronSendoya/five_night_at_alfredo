/// @description CONGELARSE Y ESPERAR (1 Seg)

// Si ya estoy esperando para viajar, no hago nada
if (state == "WARPING") exit;

// 1. Congelar estado
state = "WARPING";
path_end();
image_speed = 0;
image_index = 0;

// 2. Guardar a dónde iba 
warp_target_room = other.target_room;
warp_target_x = other.target_x;
warp_target_y = other.target_y;

// 3. Activar la cuenta regresiva (1 Segundo)
alarm[1] = 30;