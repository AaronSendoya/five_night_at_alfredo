/// @description Lógica base de IA + movimiento (par_animatronic)

// -------- 0. Sincronizar dificultad según tipo --------
switch (object_index) {
    case obj_bonnie_guitarra:
        ai_level = variable_global_exists("ai_level_bongo") ? global.ai_level_bongo : 0;
    break;
}

// dificultad normalizada
var _df_lin = clamp(ai_level / 20, 0, 1);
var _df     = _df_lin * _df_lin;

// velocidades según dificultad
var patrol_speed = move_speed * (0.8 + 0.6 * _df);
var chase_speed  = move_speed * (1.1 + 0.9 * _df);

// -------- 1. IA apagada --------
if (!global.animatronics_active || ai_level <= 0) {

    if (in_chase) director_end_chase();

    state             = AI_STATE_DEACTIVATED;
    has_target        = false;
    lose_player_timer = 0;
    patrol_timer      = 0;
    idle_frames       = 0;

    exit;
}

// actualizar cooldown de warps (lo usará el hijo)
if (warp_cooldown > 0) warp_cooldown--;

// -------- 2. Detección directa del jugador --------
if (can_see_player()) {
    last_player_x     = obj_jugador.x;
    last_player_y     = obj_jugador.y;
    lose_player_timer = 0;

    if (state != AI_STATE_CHASE) {
        if (director_request_chase()) {
            state = AI_STATE_CHASE;
        }
    }
}

// -------- 3. Máquina de estados --------
switch (state) {

    case AI_STATE_DEACTIVATED:
    break;

    case AI_STATE_IDLE:
        has_target   = false;
        patrol_timer = 0;
    break;

    case AI_STATE_PATROL:
        if (has_target) {

            // caminar evitando sólidos (obj_pared es sólido)
            mp_potential_step(target_x, target_y, patrol_speed, true);

            patrol_timer++;

            var _reached  = (point_distance(x, y, target_x, target_y) < 8);
            var _max_time = patrol_timer_max_base + (ai_level * 0.05 * room_speed);

            if (_reached || patrol_timer > _max_time) {
                has_target   = false;
                patrol_timer = 0;
                state        = AI_STATE_IDLE;
                event_user(0); // pedir nueva decisión al hijo
            }

        } else {
            state = AI_STATE_IDLE;
            event_user(0);
        }
    break;

    case AI_STATE_WARNING:
        if (!has_target) {

            var _ang2  = irandom(359);
            var _dist2 = irandom_range(
                search_radius_min,
                search_radius_max * (0.6 + _df * 0.6)
            );

            target_x = last_player_x + lengthdir_x(_dist2, _ang2);
            target_y = last_player_y + lengthdir_y(_dist2, _ang2);

            has_target   = true;
            patrol_timer = 0;

        } else {

            mp_potential_step(target_x, target_y, patrol_speed, true);

            patrol_timer++;

            var _reached2        = (point_distance(x, y, target_x, target_y) < 8);
            var _max_search_time = patrol_timer_max_base * 0.75;

            if (_reached2 || patrol_timer > _max_search_time) {
                has_target   = false;
                patrol_timer = 0;
            }
        }
    break;

    case AI_STATE_CHASE:
        if (instance_exists(obj_jugador)) {

            mp_potential_step(obj_jugador.x, obj_jugador.y, chase_speed, true);

            if (can_see_player() || can_hear_player()) {
                lose_player_timer = 0;
                last_player_x     = obj_jugador.x;
                last_player_y     = obj_jugador.y;
            } else {
                lose_player_timer++;

                var _lose_min   = room_speed * 1.5;
                var _lose_max   = room_speed * 5.0;
                var _lose_limit = lerp(_lose_max, _lose_min, _df);

                if (lose_player_timer >= _lose_limit) {
                    director_end_chase();
                    lose_player_timer = 0;

                    state      = AI_STATE_WARNING;
                    has_target = false;
                }
            }
        } else {
            director_end_chase();
            state      = AI_STATE_IDLE;
            has_target = false;
        }
    break;
}

// -------- 3.5 Idle watchdog --------
var _moved_frame = point_distance(x, y, xprevious, yprevious);

if (state == AI_STATE_IDLE && ai_level > 0 && global.animatronics_active) {

    if (_moved_frame < 0.5) idle_frames++;
    else                    idle_frames = 0;

    var _idle_limit = idle_limit_base - (_df * room_speed);
    _idle_limit = clamp(_idle_limit, room_speed * 0.5, room_speed * 3);

    if (idle_frames > _idle_limit) {
        idle_frames = 0;
        event_user(0); // fuerza nueva decisión de patrulla / búsqueda
    }
} else {
    idle_frames = 0;
}

// -------- 4. Anti-atasco LOCAL (empujón corto, sin teleports) --------
if (state == AI_STATE_PATROL || state == AI_STATE_WARNING || state == AI_STATE_CHASE) {

    var _moved       = point_distance(x, y, xprevious, yprevious);
    var _dist_target = point_distance(x, y, target_x, target_y);

    if (has_target && _dist_target > stuck_distance_threshold && _moved < 0.25) {
        stuck_timer++;
    } else {
        stuck_timer = 0;
    }

    if (stuck_timer >= stuck_time_max) {

        var _freed = false;
        var _nx, _ny;

        for (var i = 0; i < 8; i++) {
            var _ang  = i * 45;
            var _dist = 16;

            _nx = x + lengthdir_x(_dist, _ang);
            _ny = y + lengthdir_y(_dist, _ang);

            if (!collision_rectangle(_nx - 8, _ny - 8, _nx + 8, _ny + 8, obj_pared, true, true)) {
                _freed = true;
                break;
            }
        }

        if (_freed) {
            x = _nx;
            y = _ny;
        }

        has_target   = false;
        state        = AI_STATE_IDLE;
        patrol_timer = 0;
        idle_frames  = 0;
        stuck_timer  = 0;
    }

} else {
    stuck_timer = 0;
}

// -------- 5. Facing angle --------
var _dx_face = x - xprevious;
var _dy_face = y - yprevious;

if (abs(_dx_face) > 0.1 || abs(_dy_face) > 0.1) {
    facing_angle = point_direction(xprevious, yprevious, x, y);
}

// -------- 6. Clamp seguridad --------
x = clamp(x, -32, room_width  + 32);
y = clamp(y, -32, room_height + 32);
