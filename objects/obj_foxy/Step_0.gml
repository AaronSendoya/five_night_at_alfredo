/// @description IA Foxy Rufus: Cazador Audaz (Eliminación de Delay)

// =================================================================
// 0. SEGURIDAD Y BOOT (Sincronizado)
// =================================================================
if (!global.animatronics_active || my_ai_level <= 0) {
    image_speed = 0; path_end(); exit;
}

if (boot_timer_frames > 0) {
    boot_timer_frames--; image_speed = 0; path_end(); exit; 
}

// =================================================================
// 1. MECÁNICA DE LUZ (RETIRADA ESTRATÉGICA)
// =================================================================
if (global.power_on == true) {
    is_hunting_foxy = false; hunt_timer_foxy = 0;
    state = "IDLE"; 

    if (point_distance(x, y, home_x, home_y) > 20) {
        if (path_index != path_return) {
            if (mp_grid_path(grid_ia, path_return, x, y, home_x, home_y, true)) {
                path_start(path_return, velocidad_caza, path_action_stop, true);
            }
        }
        // Animación manual para ignorar al padre
        image_speed = 1;
        var _dir = direction;
        if (_dir < 0) _dir += 360;
        if (_dir > 45 && _dir <= 135) sprite_index = spr_atras;
        else if (_dir > 135 && _dir <= 225) sprite_index = spr_izquierda;
        else if (_dir > 225 && _dir <= 315) sprite_index = spr_frente;
        else sprite_index = spr_derecha;
    } else {
        path_end(); x = home_x; y = home_y;
        sprite_index = spr_frente; image_speed = 0;
    }
    exit; // BLOQUEO TOTAL: Si hay luz, el Padre no tiene poder.
} 

// =================================================================
// 2. MECÁNICA DE OSCURIDAD (CAZA SIN CUARTEL)
// =================================================================
else {
    var _player = instance_nearest(x, y, obj_jugador);
    var _seen_now = false;

    // --- VISIÓN DE ALTA PRECISIÓN ---
    if (_player != noone && !global.player_hidden) {
        var _dist = point_distance(x, y, _player.x, _player.y);
        if (_dist < 1100) {
            var _col = collision_line(x, y, _player.x, _player.y, obj_pared, false, false);
            if (_col == noone) {
                var _angle = point_direction(x, y, _player.x, _player.y);
                if (abs(angle_difference(direction, _angle)) <= 150) _seen_now = true;
            }
        }
    }

    // --- MEMORIA DE CAZA (Aumentada a 15 segundos) ---
    if (_seen_now) {
        is_hunting_foxy = true;
        hunt_timer_foxy = 900; 
    }

    if (is_hunting_foxy) {
        if (hunt_timer_foxy > 0) hunt_timer_foxy--;
        else is_hunting_foxy = false;

        // ---------------------------------------------------------
        // EL ARREGLO MAESTRO: MODO RASTREADOR BALÍSTICO
        // ---------------------------------------------------------
        var _dist_total = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : 0;
        
        if (_player != noone && _dist_total > 1200) {
            // Si el jugador está en otra isla, Foxy se vuelve una bala hacia el Warp.
            // NO usamos 'inherited', NO usamos 'IDLE', NO usamos 'Alarm 0'.
            
            var _best_w = noone;
            var _min_d = 999999;
            
            // Encuentra el Warp más cercano para saltar de isla
            for (var i = 0; i < ds_list_size(interest_points); i++) {
                var _w = interest_points[| i];
                var _d = point_distance(x, y, _w.x, _w.y);
                if (_d < _min_d) { _min_d = _d; _best_w = _w; }
            }
            
            if (_best_w != noone) {
                // Si ya estamos tocando el Warp, forzamos el viaje INSTANTÁNEO
                if (point_distance(x, y, _best_w.x + 16, _best_w.y + 16) < 40) {
                    // Bypass del retraso de 1 segundo del Padre
                    warp_target_room = _best_w.target_room;
                    warp_target_x = _best_w.target_x;
                    warp_target_y = _best_w.target_y;
                    
                    // Disparamos la alarma de ejecución en 1 frame, no en 30.
                    state = "WARPING"; 
                    alarm[1] = 1; 
                    show_debug_message("FOXY: Salto interdimensional instantáneo.");
                } 
                else if (state != "MOVING_TO_WARP") {
                    // Si no estamos cerca, corremos hacia él a máxima velocidad
                    if (mp_grid_path(grid_ia, path, x, y, _best_w.x + 16, _best_w.y + 16, true)) {
                        path_start(path, velocidad_caza, path_action_stop, true);
                        state = "MOVING_TO_WARP";
                    }
                }
            }
            exit; // Evitamos que par_animatronic meta sus pausas de IDLE
        } 
        
        // Control de agresividad: Si el Padre intenta frenarlo, Foxy se resiste
        if (state == "IDLE") alarm[0] = 2; // Solo 0.03s de espera si se detiene

        move_speed = velocidad_caza;
        chase_speed = velocidad_caza;
        event_inherited(); 
    } 
    else {
        // Patrulla normal (Velocidad reducida)
        move_speed = velocidad_normal;
        chase_speed = velocidad_normal;
        event_inherited();
    }
}