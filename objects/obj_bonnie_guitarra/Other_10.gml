/// @description Reacción ODM específica de Bongo (patrulla / búsqueda)

// 1. Ver jugador → persecución
if (can_see_player()) {

    has_seen_player = true;

    if (director_request_chase()) {
        state             = AI_STATE_CHASE;
        lose_player_timer = 0;
        last_player_x     = obj_jugador.x;
        last_player_y     = obj_jugador.y;
    }
    exit;
}

// 2. Oír jugador → WARNING
if (can_hear_player()) {

    has_seen_player = true;

    state      = AI_STATE_WARNING;
    target_x   = obj_jugador.x;
    target_y   = obj_jugador.y;
    has_target = true;
    exit;
}

// 3. No ve ni oye → patrulla normal
state = AI_STATE_PATROL;

var _min_x = patrol_min_x;
var _max_x = patrol_max_x;
var _min_y = patrol_min_y;
var _max_y = patrol_max_y;

var _p = choose_patrol_point(_min_x, _max_x, _min_y, _max_y);

target_x     = _p.x;
target_y     = _p.y;
has_target   = true;
patrol_timer = 0;
