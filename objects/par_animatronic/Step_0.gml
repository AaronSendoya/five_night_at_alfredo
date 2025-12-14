/// @description Control Total (Visión Ampliada + Patrulla + Persecución)

// --- 1. SISTEMA DE VISIÓN ---
var _player = instance_nearest(x, y, obj_jugador);
var _seen = false;

if (_player != noone) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    
    // Rango de visión
    if (_dist < 999) {
        // Raycast: Solo obj_pared bloquea la visión
        var _col = collision_line(x, y, _player.x, _player.y, obj_pared, false, false);
        
        if (_col == noone) {
            // Ángulo
            var _angle_to_player = point_direction(x, y, _player.x, _player.y);
            var _angle_diff = abs(angle_difference(direction, _angle_to_player));
            
            // Ángulo de 120 (Visión periférica amplia)
            if (_angle_diff <= 120) { 
                _seen = true;
            }
        }
    }
}

// SI TE VE: Forzar estado de persecución inmediatamente
if (_seen) {
    state = "CHASE";
}

// --- 2. MÁQUINA DE ESTADOS ---

// CASO A: PERSECUCIÓN
if (state == "CHASE") {
    
    // 1. SI LO VEO: Actualizo la ruta hacia él
    if (_seen) {
        // Optimizacion: Recalcula ruta cada 15 frames
        if (current_time % 15 == 0) {
            
            // INTENTO 1: Usar el Grid (Lo ideal)
            if (mp_grid_path(grid_ia, path, x, y, _player.x, _player.y, true)) {
                path_start(path, 5.0, path_action_stop, true); 
            } 
            // INTENTO 2 (EL ARREGLO): Si el Grid falla (por eso se congelaba), pero te veo...
            else {
                path_end(); // Deja de intentar seguir el camino viejo
                // Muévete directo hacia el jugador con la MISMA velocidad (5.0)
                // Usamos mp_potential_step para que no se choque con cosas mientras va directo
                mp_potential_step(_player.x, _player.y, 5.0, false);
            }
        }
    } 
    // 2. SI NO LO VEO (Se escondió o salió del ángulo):
    else {
        // Dejamos que termine su camino actual (ir a la última posición conocida)
        
        if (path_position >= 0.98) {
            path_end();     
            state = "IDLE"; 
            alarm[0] = 20;  
        }
        
        // Anti-atasco mientras persigue a ciegas
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
        alarm[0] = irandom_range(30, 60); 
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

// --- 3. ANIMACIÓN Y DIRECCIÓN (CORREGIDO) ---

// CAMBIO IMPORTANTE:
// Antes decía: if (path_speed > 0)
// Ahora dice:  if (path_speed > 0 || x != xprevious || y != yprevious)
// Explicación: Cuando usamos el "Arreglo del Intento 2" arriba, path_speed es 0,
// pero el objeto se mueve. Con este cambio, detectamos CUALQUIER movimiento para animar.

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