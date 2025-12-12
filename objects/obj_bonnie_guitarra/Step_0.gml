/// @description IA de Bongo + animación

// Si la IA general está apagada -> pose neutra
if (!global.animatronics_active || ai_level <= 0) {

    sprite_index = sp_bonnie_caminar_frente_guitarra;
    image_speed  = 0;
    image_index  = 0;
    image_angle  = 0;

    exit;
}

var _prev_x = x;
var _prev_y = y;

// FSM y movimiento del padre
event_inherited();

// Animación según movimiento
var _dx = x - _prev_x;
var _dy = y - _prev_y;
var _moving = (abs(_dx) > 0.1) || (abs(_dy) > 0.1);

if (_moving) {
    image_speed = 1;

    if (abs(_dy) >= abs(_dx)) {
        if (_dy > 0)  sprite_index = sp_bonnie_caminar_frente_guitarra;
        else          sprite_index = sp_bonnie_caminar_atras_guitarra;
    } else {
        if (_dx > 0)  sprite_index = sp_bonnie_caminar_derecha_guitarra;
        else          sprite_index = sp_bonnie_caminar_izquierda_guitarra;
    }
} else {
    image_speed = 0;
    image_index = 0;
}

image_angle = 0;
