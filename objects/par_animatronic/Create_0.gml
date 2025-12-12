/// @description Setup base IA animatrónico

// ------------ ESTADOS ------------
AI_STATE_DEACTIVATED = 0;
AI_STATE_IDLE        = 1;
AI_STATE_PATROL      = 2;
AI_STATE_WARNING     = 3;
AI_STATE_CHASE       = 4;

state = AI_STATE_DEACTIVATED;

// ------------ MOVIMIENTO ------------
move_speed = 1.5;
target_x   = x;
target_y   = y;
has_target = false;

// Dificultad 0–20 (el hijo la sincroniza con globals)
ai_level = 0;

// Director de persecución
in_chase = false;

// ------------ MEMORIA DEL JUGADOR ------------
last_player_x = x;
last_player_y = y;

lose_player_timer    = 0;
lose_player_time_max = room_speed * 3;

// ------------ PATRULLA / BÚSQUEDA ------------
patrol_timer          = 0;
patrol_timer_max_base = room_speed * 2;
search_radius_min     = 96;
search_radius_max     = 256;

// ------------ ODM (Oportunidad de movimiento) ------------
odm_min_time = room_speed * 1;
odm_max_time = room_speed * 3;
alarm[0]     = irandom_range(odm_min_time, odm_max_time);

// ------------ VISIÓN ------------
vision_range      = 720;
vision_half_angle = 90;
facing_angle      = 90;

// ------------ OÍDO ------------
hearing_range_base   = 180;
hearing_noise_factor = 1.5;

// ------------ DIRECTOR ------------
director_request_chase = function () {
    if (in_chase) return true;

    if (global.active_chases < global.max_chases) {
        global.active_chases += 1;
        in_chase = true;
        return true;
    }
    return false;
};

director_end_chase = function () {
    if (in_chase) {
        in_chase = false;
        global.active_chases = max(0, global.active_chases - 1);
    }
};

// ------------ VER JUGADOR ------------
can_see_player = function () {
    if (!instance_exists(obj_jugador)) return false;

    var _dist = point_distance(x, y, obj_jugador.x, obj_jugador.y);
    if (_dist > vision_range) return false;

    var _dir_to_player = point_direction(x, y, obj_jugador.x, obj_jugador.y);
    var _diff          = angle_difference(facing_angle, _dir_to_player);
    if (abs(_diff) > vision_half_angle) return false;

    if (collision_line(x, y, obj_jugador.x, obj_jugador.y, obj_pared, true, true)) {
        return false;
    }

    return true;
};

// ------------ OÍR JUGADOR ------------
can_hear_player = function () {
    if (!instance_exists(obj_jugador)) return false;

    var _dist = point_distance(x, y, obj_jugador.x, obj_jugador.y);

    var _noise = 0;
    if (variable_instance_exists(obj_jugador, "noise_level")) {
        _noise = obj_jugador.noise_level;
    }

    var _effective_range = hearing_range_base + (_noise * hearing_noise_factor);

    return (_dist <= _effective_range);
};

// ------------ NOMBRE ESTADO (debug) ------------
get_state_name = function () {
    switch (state) {
        case AI_STATE_DEACTIVATED: return "DEACTIVATED";
        case AI_STATE_IDLE:        return "IDLE";
        case AI_STATE_PATROL:      return "PATROL";
        case AI_STATE_WARNING:     return "WARNING";
        case AI_STATE_CHASE:       return "CHASE";
    }
    return "UNKNOWN";
};

// ------------ ANTI-ATASCO LOCAL ------------
stuck_timer              = 0;
stuck_time_max           = room_speed * 1.0;
stuck_distance_threshold = 16;

// ------------ ANTI-STUCK GLOBAL (no lo usamos fuerte pero por si acaso) ------------
stuck_last_x = x;
stuck_last_y = y;
stuck_frames = 0;
stuck_limit  = room_speed;

// ------------ MEMORIA PATRULLA ------------
recent_patrol_points   = ds_list_create();
recent_patrol_max      = 5;
recent_patrol_min_dist = 160;

/// @func choose_patrol_point(_min_x,_max_x,_min_y,_max_y)
choose_patrol_point = function(_min_x, _max_x, _min_y, _max_y) {

    var _best_x = x;
    var _best_y = y;
    var _found  = false;

    repeat (12) {
        var _tx = irandom_range(_min_x, _max_x);
        var _ty = irandom_range(_min_y, _max_y);

        if (point_distance(x, y, _tx, _ty) < 64) continue;

        // no caer dentro de paredes
        if (collision_rectangle(_tx - 8, _ty - 8, _tx + 8, _ty + 8, obj_pared, true, true))
            continue;

        var _ok = true;
        var _sz = ds_list_size(recent_patrol_points);

        for (var i = 0; i < _sz; i++) {
            var _pt = recent_patrol_points[| i];
            if (point_distance(_tx, _ty, _pt[0], _pt[1]) < recent_patrol_min_dist) {
                _ok = false;
                break;
            }
        }

        if (_ok) {
            _best_x = _tx;
            _best_y = _ty;
            _found  = true;
            break;
        }
    }

    if (!_found) {
        var _tx2, _ty2, _safe = false, _loops = 0;

        while (!_safe && _loops < 16) {
            _loops++;
            _tx2 = irandom_range(_min_x, _max_x);
            _ty2 = irandom_range(_min_y, _max_y);

            _safe = !collision_rectangle(
                _tx2 - 8, _ty2 - 8,
                _tx2 + 8, _ty2 + 8,
                obj_pared, true, true
            );
        }

        _best_x = _tx2;
        _best_y = _ty2;
    }

    var _entry = [_best_x, _best_y];
    ds_list_add(recent_patrol_points, _entry);
    while (ds_list_size(recent_patrol_points) > recent_patrol_max) {
        ds_list_delete(recent_patrol_points, 0);
    }

    return { x: _best_x, y: _best_y };
};

// ------------ IDLE WATCHDOG ------------
idle_frames     = 0;
idle_limit_base = room_speed * 2;

// ------------ WARPS (solo cooldown, la lógica va en el hijo) ------------
warp_cooldown      = 0;
warp_cooldown_max  = room_speed; // ~1s
