/// @description Control Total (Con Bloqueo de IA)

// ---------------------------------------------------------
// 0. GATEKEEPER (Control de Actividad)
// ---------------------------------------------------------

// CASO 1: ¿Soy Nivel 0? (Dificultad apagada)
if (!is_active_by_level) {
    image_speed = 0;
    image_index = 0;
    path_end(); // Aseguramos que no se mueva
    exit; 
}

// CASO 2: ¿Son las 12:00 AM y el juego aún no arranca la noche?
if (!global.animatronics_active) {
    image_speed = 0;
    image_index = 0;
    path_end();
    exit; 
}

// CASO 3: TEMPORIZADOR INDIVIDUAL (El Despertador)
// Si la noche ya empezó, empezamos a descontar mi tiempo personal
if (boot_timer_frames > 0) {
    boot_timer_frames -= 1; // Restar 1 frame
    
    // --- CORRECCIÓN DEL BUG VISUAL ---
    image_speed = 0;
    image_index = 0;
    path_end();    // Frenamos cualquier movimiento residual
    alarm[0] = 60; // ¡IMPORTANTE! Posponemos la alarma de patrulla constantemente
                   // Así nunca llega a cero mientras estemos "durmiendo".
    
    exit; // Aún estoy "durmiendo" o preparándome
}

// ---------------------------------------------------------
// IA ORIGINAL (INTACTA)
// ---------------------------------------------------------

// --- 1. SISTEMA DE VISIÓN ---
var _player = instance_nearest(x, y, obj_jugador);
var _seen = false;

if (_player != noone) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    
    // Rango de visión
    if (_dist < 999) {
        var _col = collision_line(x, y, _player.x, _player.y, obj_pared, false, false);
        if (_col == noone) {
            var _angle_to_player = point_direction(x, y, _player.x, _player.y);
            var _angle_diff = abs(angle_difference(direction, _angle_to_player));
            if (_angle_diff <= 120) { 
                _seen = true;
            }
        }
    }
}

// SI TE VE: Forzar estado de persecución
if (_seen) {
    state = "CHASE";
}

// --- 2. MÁQUINA DE ESTADOS ---

// CASO A: PERSECUCIÓN
if (state == "CHASE") {
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
        if (path_position >= 0.98) {
            path_end();     
            state = "IDLE"; 
            alarm[0] = 20;  
        }
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

// CASO B: QUIETO
else if (state == "IDLE") {
    image_speed = 0;
    image_index = 0;
}

// CASO C: PATRULLANDO
else if (state == "MOVING") {
    image_speed = 1;
    
    if (path_position >= 0.98) {
        path_end();
        state = "IDLE";
        alarm[0] = irandom_range(patrol_wait_min, patrol_wait_max); 
    }
    
    if (point_distance(x, y, xp, yp) < 1) {
        stuck_timer++;
        if (stuck_timer > 60) { 
            path_end();
            state = "IDLE";
            alarm[0] = 5; 
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