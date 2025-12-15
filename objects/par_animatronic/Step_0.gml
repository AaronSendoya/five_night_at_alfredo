/// @description Control Total + Paciencia + Persecución

// ---------------------------------------------------------
// 0. GATEKEEPER (Control de Actividad)
// ---------------------------------------------------------

// Si estoy escondido, me ignoran
if (global.player_hidden) {
    if (state == "CHASE") {
        state = "IDLE";
        path_end();
        image_speed = 0;
        alarm[0] = 60; // Pausa para repensar
    }
    // NOTA: Aún estando escondido, el animatrónico puede seguir patrullando
    // o decidir irse si se le acaba la paciencia.
}

if (!is_active_by_level || !global.animatronics_active) {
    image_speed = 0;
    image_index = 0;
    path_end();
    exit; 
}

if (boot_timer_frames > 0) {
    boot_timer_frames -= 1; 
    image_speed = 0;
    image_index = 0;
    path_end();    
    alarm[0] = 60; 
    exit; 
}

// ---------------------------------------------------------
// IA ORIGINAL MEJORADA
// ---------------------------------------------------------

// --- 1. SISTEMA DE VISIÓN ---
// (Solo si NO está escondido)
if (!global.player_hidden) {
    var _player = instance_nearest(x, y, obj_jugador);
    var _seen = false;

    if (_player != noone) {
        var _dist = point_distance(x, y, _player.x, _player.y);
        
        if (_dist < 999) {
            var _col = collision_line(x, y, _player.x, _player.y, obj_pared, false, false);
            if (_col == noone) {
                var _angle_to_player = point_direction(x, y, _player.x, _player.y);
                var _angle_diff = abs(angle_difference(direction, _angle_to_player));
                if (_angle_diff <= 150) { 
                    _seen = true;
                }
            }
        }
    }

    if (_seen) {
        state = "CHASE";
        room_patience_timer = room_patience_max; // Resetear paciencia si ve algo interesante
    }
}

// --- 2. MÁQUINA DE ESTADOS ---

// CASO A: PERSECUCIÓN
if (state == "CHASE") {
    // (Tu lógica de persecución se mantiene igual, es sólida)
    if (_seen) {
        if (current_time % 15 == 0) {
            if (mp_grid_path(grid_ia, path, x, y, _player.x, _player.y, true)) {
                path_start(path, chase_speed, path_action_stop, true); 
            } 
            else {
                path_end(); 
                mp_potential_step(_player.x, _player.y, chase_speed, false);
            }
        }
    } 
    else {
        // Perdió de vista -> Volver a patrullar
        if (path_position >= 0.98) {
            path_end();      
            state = "IDLE"; 
            alarm[0] = 20;  
        }
        // Lógica de atasco...
        if (path_speed > 0 && x == xp && y == yp) {
             stuck_timer++;
             if (stuck_timer > 30) { 
                 state = "IDLE";
                 alarm[0] = 10;
                 stuck_timer = 0;
             }
        } else {
             stuck_timer = 0;
        }
        xp = x;
        yp = y;
    }
}

// CASO B: QUIETO (Pensando)
else if (state == "IDLE") {
    image_speed = 0;
    image_index = 0;
    // El Alarm[0] se encargará de sacarlo de aquí
}

// CASO C: PATRULLANDO / MIGRANDO
else if (state == "MOVING") {
    image_speed = 1;
    
    // --- GESTIÓN DE PACIENCIA ---
    // Mientras camino, me aburro poco a poco
    if (room_patience_timer > 0) {
        room_patience_timer -= 1;
    }
    
    // CHEQUEO DE LLEGADA A DESTINO
    if (path_position >= 0.98) {
        path_end();
        state = "IDLE";
        
        // Si llegué a mi destino, decido qué hacer:
        // ¿Me queda paciencia? -> Explorar otro punto local.
        // ¿Se acabó la paciencia? -> Alarm[0] elegirá un Warp.
        alarm[0] = irandom_range(patrol_wait_min, patrol_wait_max); 
    }
    
    // CHEQUEO DE ATASCO
    if (point_distance(x, y, xp, yp) < 1) {
        stuck_timer++;
        if (stuck_timer > 60) { 
            path_end();
            state = "IDLE";
            alarm[0] = 5; // Recalcular ruta rápido
            stuck_timer = 0;
        }
    } else {
        stuck_timer = 0; 
    }
    
    xp = x;
    yp = y;
}

// --- 3. ANIMACIÓN Y DIRECCIÓN ---
if (path_speed > 0 || x != xprevious || y != yprevious) { 
    var _dir = round(direction / 90);
    if (_dir == 4) _dir = 0;
    
    switch(_dir) {
        case 0: if(spr_derecha != noone) sprite_index = spr_derecha; break;
        case 1: if(spr_atras != noone) sprite_index = spr_atras; break;
        case 2: if(spr_izquierda != noone) sprite_index = spr_izquierda; break;
        case 3: if(spr_frente != noone) sprite_index = spr_frente; break;
    }
    image_speed = 1;
} else {
    image_speed = 0;
    image_index = 0;
}