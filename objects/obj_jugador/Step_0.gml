/// @description Movimiento, Sprint, Paredes e Interacción

// Si el jugador está muerto, no hace nada
if (player_state != PLAYER_STATE_DEAD) {
    
    // --------------------------------------------------------
    // BLOQUEO POR RECARGA DE LINTERNA (Crank)
    // --------------------------------------------------------
    // Si estamos dando cuerda, nos quedamos quietos
    if (instance_exists(obj_linterna)) {
        if (obj_linterna.is_cranking) {
            image_speed = 0; 
            image_index = 0; 
            exit; 
        }
    }

    // ========================================================
    //    CHECK MAESTRO: ¿PUEDE MOVERSE?
    // ========================================================
    if (puede_moverse) {

        // 1. CONTROLES DE DIRECCIÓN
        var _derecha  = keyboard_check(vk_right) || keyboard_check(ord("D"));
        var _izquierda= keyboard_check(vk_left)  || keyboard_check(ord("A"));
        var _abajo    = keyboard_check(vk_down)  || keyboard_check(ord("S"));
        var _arriba   = keyboard_check(vk_up)    || keyboard_check(ord("W"));

        // Vector de movimiento
        var _mx = _derecha - _izquierda;
        var _my = _abajo   - _arriba;

        // Si está escondido o interactuando, forzamos quieto
        if (player_state == PLAYER_STATE_HIDDEN || player_state == PLAYER_STATE_INTERACTING) {
            _mx = 0;
            _my = 0;
        }

        // 2. SPRINT / CARRERA (SHIFT)
        corriendo = false;
        var _shift = keyboard_check(vk_shift);

        // Requisitos para correr: Shift + Energía + No Cooldown + Estado Normal
        if (_shift
            && sprint_actual > 0
            && sprint_cooldown <= 0
            && (player_state == PLAYER_STATE_NORMAL || player_state == PLAYER_STATE_CHASED)) {
            corriendo = true;
        }

        // Gestión de Velocidad y Energía
        if (corriendo) {
            velocidad_actual = velocidad_run;
            sprint_actual -= sprint_gasto;
            
            if (sprint_actual <= 0) {
                sprint_actual = 0;
                corriendo = false;
                sprint_cooldown = sprint_cooldown_time;
                velocidad_actual = velocidad_walk;
            }
        } else {
            velocidad_actual = velocidad_walk;
            
            // Recuperar energía si no hay cooldown
            if (sprint_cooldown <= 0) {
                sprint_actual += sprint_recuperacion;
                if (sprint_actual > sprint_max) sprint_actual = sprint_max;
            }
        }

        // Reducir cooldown
        if (sprint_cooldown > 0) {
            sprint_cooldown -= 1;
        }

        // 3. CALCULAR VELOCIDAD FINAL (H/V)
        var _len = point_distance(0, 0, _mx, _my);
        var _dir_x = 0;
        var _dir_y = 0;

        if (_len > 0) {
            _dir_x = _mx / _len;
            _dir_y = _my / _len;
        }

        var _hspd = _dir_x * velocidad_actual;
        var _vspd = _dir_y * velocidad_actual;

        // 4. COLISIONES CON PAREDES (obj_pared y obj_pared_2)
        
        // --- HORIZONTAL ---
        if (place_meeting(x + _hspd, y, obj_pared) || place_meeting(x + _hspd, y, obj_pared_2)) {
            while (!place_meeting(x + sign(_hspd), y, obj_pared) && !place_meeting(x + sign(_hspd), y, obj_pared_2)) {
                x += sign(_hspd);
            }
            _hspd = 0;
        }
        x += _hspd;

        // --- VERTICAL ---
        if (place_meeting(x, y + _vspd, obj_pared) || place_meeting(x, y + _vspd, obj_pared_2)) {
            while (!place_meeting(x, y + sign(_vspd), obj_pared) && !place_meeting(x, y + sign(_vspd), obj_pared_2)) {
                y += sign(_vspd);
            }
            _vspd = 0;
        }
        y += _vspd;

        // 5. ANIMACIÓN
        if (_hspd != 0 || _vspd != 0) {
            image_speed = 1; 
            if (_vspd > 0)      sprite_index = sp_shadow_caminar_frente;
            else if (_vspd < 0) sprite_index = sp_shadow_caminar_atras;
            else if (_hspd > 0) sprite_index = sp_shadow_caminar_derecha;
            else if (_hspd < 0) sprite_index = sp_shadow_caminar_izquierda;
        } else {
            image_speed = 0;
            image_index = 0;
        }

        // 6. DETECCIÓN DE INTERACCIÓN (E)
        puede_interactuar = false;
        interact_target   = noone;
        var _inst = instance_nearest(x, y, par_interactable);

        if (_inst != noone) {
            if (point_distance(x, y, _inst.x, _inst.y) <= interact_range) {
                puede_interactuar = true;
                interact_target = _inst;
            }
        }

        // 7. EJECUTAR INTERACCIÓN
        if (puede_interactuar && keyboard_check_pressed(ord("E"))) {
            switch (interact_target.object_index) {
                case obj_puerta:
                    with (interact_target) abierta = !abierta;
                    break;

                case obj_locker:
                    if (!is_hidden) {
                        player_state = PLAYER_STATE_HIDDEN;
                        is_hidden    = true;
                        hiding_spot  = interact_target;
                        x = interact_target.x;
                        y = interact_target.y;
                    } else {
                        if (hiding_spot == interact_target) {
                            player_state = PLAYER_STATE_NORMAL;
                            is_hidden    = false;
                            hiding_spot  = noone;
                        }
                    }
                    break;

                case obj_item:
                    with (interact_target) instance_destroy();
                    break;
                
                // Añade más casos aquí (obj_generador, etc.)
            }
        }

    } else {
        // SI NO PUEDE MOVERSE (Cutscenes, etc.)
        image_speed = 0;
        image_index = 0;
    }
}