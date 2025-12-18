/// @description Movimiento, Colisiones, Sprint e Interacción

// Si el jugador está muerto, no hace nada
if (player_state != PLAYER_STATE_DEAD) {
	    // ========================================================
    //   CHECK DE MUERTE: Colisión con Animatrónicos
    // ========================================================
    // Si NO estamos escondidos y tocamos a un animatrónico...
    if (player_state != PLAYER_STATE_HIDDEN) {
        if (place_meeting(x, y, par_animatronic)) {
            
            // 1. Cambiar estado a MUERTO para inmovilizar al jugador
            player_state = PLAYER_STATE_DEAD;
            velocidad_actual = 0;
            image_speed = 0;
            
            // 2. Detener sonidos de ambiente si quieres (opcional)
            audio_stop_all();
            
            // 3. Crear el objeto del susto
            instance_create_depth(0, 0, -10000, obj_jumpscare);
            
            exit; // Dejar de ejecutar el resto del código de movimiento
        }
    }
	
	// BLOQUEO POR RECARGA DE LINTERNA
	// Si la linterna existe y estamos dando cuerda...
	if (instance_exists(obj_linterna)) {
	    if (obj_linterna.is_cranking) {
	        // Detener animación si tienes
	        image_speed = 0; 
	        image_index = 0; 
	        exit; 
	    }
	}

    // ========================================================
    //   CHECK MAESTRO: ¿PUEDE MOVERSE? (Freno para transiciones)
    // ========================================================
    if (puede_moverse) {

        // =========================
        // 1. CONTROLES DE DIRECCIÓN
        // =========================
        var _derecha  = keyboard_check(vk_right) || keyboard_check(ord("D"));
        var _izquierda= keyboard_check(vk_left)  || keyboard_check(ord("A"));
        var _abajo    = keyboard_check(vk_down)  || keyboard_check(ord("S"));
        var _arriba   = keyboard_check(vk_up)    || keyboard_check(ord("W"));

        // Vector de movimiento (sin normalizar)
        var _mx = _derecha - _izquierda;
        var _my = _abajo   - _arriba;

        // Si está escondido o interactuando, no se mueve
        if (player_state == PLAYER_STATE_HIDDEN || player_state == PLAYER_STATE_INTERACTING) {
            _mx = 0;
            _my = 0;
        }

        // =========================
        // 2. SPRINT / CARRERA (SHIFT)
        // =========================

        // Por defecto asumimos que NO corre
        corriendo = false;

        // Solo puede correr si:
        // - está pulsando SHIFT
        // - tiene energía de sprint
        // - NO está en cooldown
        // - está en estado NORMAL o CHASED (no escondido / no interactuando)
        var _shift = keyboard_check(vk_shift);

        if (_shift
            && sprint_actual > 0
            && sprint_cooldown <= 0
            && (player_state == PLAYER_STATE_NORMAL || player_state == PLAYER_STATE_CHASED)) {
            corriendo = true;
        }

        // Ajustar velocidad_actual según esté corriendo o no
        if (corriendo) {
            velocidad_actual = velocidad_run;
            // gastar energía
            sprint_actual -= sprint_gasto;
            if (sprint_actual <= 0) {
                sprint_actual = 0;
                corriendo = false;
                // activamos cooldown
                sprint_cooldown = sprint_cooldown_time;
                velocidad_actual = velocidad_walk;
            }
        } else {
            velocidad_actual = velocidad_walk;

            // Si no está corriendo, y no hay cooldown, se recupera energía
            if (sprint_cooldown <= 0) {
                sprint_actual += sprint_recuperacion;
                if (sprint_actual > sprint_max) sprint_actual = sprint_max;
            }
        }

        // Actualizar cooldown si está activo
        if (sprint_cooldown > 0) {
            sprint_cooldown -= 1;
        }

        // =========================
        // 3. CALCULAR VELOCIDADES H/V
        // =========================

        // Normalizar movimiento (para no ir más rápido en diagonal)
        var _len = point_distance(0, 0, _mx, _my);
        var _dir_x = 0;
        var _dir_y = 0;

        if (_len > 0) {
            _dir_x = _mx / _len;
            _dir_y = _my / _len;
        }

        var _hspd = _dir_x * velocidad_actual;
        var _vspd = _dir_y * velocidad_actual;

        // ===========================================
        // 4. COLISIONES CON obj_pared Y obj_pared_2
        // ===========================================

        // --- HORIZONTAL ---
        // Chequeamos si choca con pared NORMAL o pared TRANSPARENTE
        if (place_meeting(x + _hspd, y, obj_pared) || place_meeting(x + _hspd, y, obj_pared_2)) {
            // Loop while: Mientras NO haya colisión ni con uno ni con otro a 1 pixel, nos acercamos
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

        // =========================
        // 5. SPRITES DE MOVIMIENTO
        // =========================
        if (_hspd != 0 || _vspd != 0) {
            image_speed = 1; // animación de pasos

            if (_vspd > 0) {          // ABAJO
                sprite_index = sp_shadow_caminar_frente;
            } else if (_vspd < 0) {   // ARRIBA
                sprite_index = sp_shadow_caminar_atras;
            } else if (_hspd > 0) {   // DERECHA
                sprite_index = sp_shadow_caminar_derecha;
            } else if (_hspd < 0) {   // IZQUIERDA
                sprite_index = sp_shadow_caminar_izquierda;
            }
        } else {
            image_speed = 0;
            image_index = 0;
        }

        // =========================
        // 6. DETECCIÓN DE INTERACCIÓN (E)
        // =========================

        // Por ahora, buscamos cualquier objeto que herede de par_interactable
        puede_interactuar = false;
        interact_target   = noone;

        // Busca el más cercano al jugador
        var _inst = instance_nearest(x, y, par_interactable);

        if (_inst != noone) {
            // Chequear si está dentro del rango
            if (point_distance(x, y, _inst.x, _inst.y) <= interact_range) {
                puede_interactuar = true;
                interact_target = _inst;
            }
        }

        // =========================
        // 7. USO DE TECLA E (switch/case)
        // =========================

        if (puede_interactuar && keyboard_check_pressed(ord("E"))) {

            // switch sobre el tipo de objeto con el que vamos a interactuar
            switch (interact_target.object_index) {

                case obj_puerta:
                    // Abrir / cerrar puerta
                    with (interact_target) {
                        abierta = !abierta;
                    }
                break;

                case obj_locker:
                    // Entrar / salir de escondite
                    if (!is_hidden) {
                        // ENTRAR
                        player_state = PLAYER_STATE_HIDDEN;
                        is_hidden    = true;
                        hiding_spot  = interact_target;
                        x = interact_target.x;
                        y = interact_target.y;
                    } else {
                        // SALIR
                        if (hiding_spot == interact_target) {
                            player_state = PLAYER_STATE_NORMAL;
                            is_hidden    = false;
                            hiding_spot  = noone;
                        }
                    }
                break;

                case obj_item:
                    // Recoger item
                    with (interact_target) {
                        instance_destroy();
                    }
                break;

                case obj_generador:
                    // Futura lógica
                break;
            }
        }

    } else {
        // ========================================================
        //  SI ESTÁ BLOQUEADO (TRANSICIÓN): QUEDARSE QUIETO
        // ========================================================
        image_speed = 0;
        image_index = 0; // O el frame de "parado" que prefieras
    }
}