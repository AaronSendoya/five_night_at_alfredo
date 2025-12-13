/// @description Control Total (Visión Ampliada + Patrulla + Persecución)

// --- 1. SISTEMA DE VISIÓN ---
var _player = instance_nearest(x, y, obj_jugador);
var _seen = false;

if (_player != noone) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    
    // Rango de visión
    if (_dist < 900) {
        // Raycast: Solo obj_pared bloquea la visión (obj_pared_2 es transparente)
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
            if (mp_grid_path(grid_ia, path, x, y, _player.x, _player.y, true)) {
                path_start(path, 4.0, path_action_stop, true); // Velocidad persecución
            }
        }
    } 
    // 2. SI NO LO VEO (Se escondió o salió del ángulo):
    else {
        // AQUÍ ESTABA EL ERROR: Antes hacíamos path_end() inmediatamente.
        // AHORA: Dejamos que termine su camino actual (ir a la última posición conocida)
        
        // Solo nos rendimos si ya llegamos al destino y seguimos sin verlo
        if (path_position >= 0.98) {
            path_end();     // Ahora sí frenamos
            state = "IDLE"; 
            alarm[0] = 20;  // Pequeña pausa antes de volver a patrullar
        }
        
        // Opcional: Si se quedó atascado intentando llegar a esa última posición
        if (path_speed > 0 && x == xp && y == yp) {
             stuck_timer++;
             if (stuck_timer > 30) { // Si lleva medio segundo atascado persiguiendo un fantasma
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
    // Espera a que la Alarm 0 se active para moverse
}

// CASO C: PATRULLANDO
else if (state == "MOVING") {
    image_speed = 1;
    
    // Chequear si llegó al final del camino
    if (path_position >= 0.98) {
        path_end();
        state = "IDLE";
        // CAMBIO: Espera variable y corta (entre 0.5 y 1.5 segundos)
        // Antes era fijo 60. Ahora es más impredecible y rápido.
		// 30 frames = 0.5 segundos
		// 60 frames = 1.0 segundo
        alarm[0] = irandom_range(30, 60); 
    }
    
    // Sistema Anti-Atascamiento
    if (point_distance(x, y, xp, yp) < 1) {
        stuck_timer++;
        if (stuck_timer > 60) { 
            path_end();
            state = "IDLE";
            alarm[0] = 5; // Reacciona casi instantáneo si se atasca
            stuck_timer = 0;
        }
    } else {
        stuck_timer = 0; 
    }
    
    // Actualizar posición para el siguiente frame
    xp = x;
    yp = y;
}

// --- 3. ANIMACIÓN Y DIRECCIÓN ---
if (path_speed > 0) { 
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