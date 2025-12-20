/// @description Lógica Principal (Switch)

// =========================================================
// 1. GESTIÓN DE AUDIO GLOBAL (Fuera del switch)
// =========================================================
if (visual_state != "GAME" || game_ended) {
    if (amb_started) {
        audio_stop_sound(snd_ambience);
        amb_started = false;
    }
}

// =========================================================
// 2. MÁQUINA DE ESTADOS
// =========================================================
switch (visual_state) {

    // -----------------------------------------------------
    // CASO: INTRODUCCIÓN
    // -----------------------------------------------------
    case "INTRO":
        if (intro_timer > 0) {
            intro_timer -= 1;
        } else {
            visual_state = "GAME";
            alarm[0] = 60; 
        }
        break; 

    // -----------------------------------------------------
    // CASO: TUTORIAL
    // -----------------------------------------------------
    case "TUTORIAL":
        // El obj_tutorial_controller maneja todo
        break;

    // -----------------------------------------------------
    // CASO: JUEGO EN CURSO (GAME)
    // -----------------------------------------------------
    case "GAME":
        if (game_ended) break;

        // --- A. RELOJ DEL JUEGO ---
        game_timer += delta_time / 1000000;
        var _hours_passed = floor(game_timer / seconds_per_hour);

        // VERIFICAR VICTORIA (6 AM)
        if (_hours_passed >= 6) {
            visual_state = "OUTRO";
            game_ended = true;
            global.animatronics_active = false;

            with (par_animatronic) { alarm[0] = -1; state = "IDLE"; }

            if (!played_6am) {
                audio_play_sound(snd_6am, 100, false);
                played_6am = true;
            }

            break;
        }

        // Actualización Visual del Reloj
        var _raw_hour = start_hour + _hours_passed;
        if (_raw_hour > 12) _raw_hour -= 12;
        current_hour_display = _raw_hour;

        var _seconds_into_hour = game_timer % seconds_per_hour;
        current_minute_display = floor((_seconds_into_hour / seconds_per_hour) * 60);

        // --- B. SISTEMA DE FALLOS ELÉCTRICOS ---
        if (global.animatronics_active) {
            fuse_system_timer += delta_time / 1000000;

            if (fuse_system_timer >= global.fuse_interval) {
                fuse_system_timer = 0;
                if (random(100) < global.fuse_chance) {
                    if (instance_exists(obj_panel_fusibles)) {
                        with (obj_panel_fusibles) quemar_fusible_aleatorio();
                    }
                }
            }
        }

        // --- C. SPAWNER AUTOMÁTICO DE FUSIBLES (CORREGIDO PAREDES) ---
        if (variable_global_exists("night_config")) {

            // Verificamos configuración
            var _spawn_time = -1;
            if (variable_struct_exists(global.night_config, "fuse_spawn_seconds")) {
                _spawn_time = global.night_config.fuse_spawn_seconds;
            }

            // Solo ejecutamos si el tiempo es válido (> 0)
            if (_spawn_time > 0) {
                fuse_spawn_timer += delta_time / 1000000;

                if (fuse_spawn_timer >= _spawn_time) {
                    fuse_spawn_timer = 0;

                    // --- BÚSQUEDA DE POSICIÓN ---
                    var _spawn_x = 0;
                    var _spawn_y = 0;
                    var _encontrado = false;
                    var _intentos = 0;
                    var _margen = 80;

                    while (_intentos < 100) {
                        _spawn_x = irandom_range(_margen, room_width - _margen);
                        _spawn_y = irandom_range(_margen, room_height - _margen);

                        // Verificamos que NO colisione con obj_pared Y TAMPOCO con obj_pared_2
                        var _libre_pared_1 = !position_meeting(_spawn_x, _spawn_y, obj_pared);
                        var _libre_pared_2 = !position_meeting(_spawn_x, _spawn_y, obj_pared_2);

                        if (_libre_pared_1 && _libre_pared_2) {
                            _encontrado = true;
                            break;
                        }
                        _intentos++;
                    }

                    if (_encontrado) {
                        // Usar la capa correcta
                        if (layer_exists("Instances_fusibles")) {
                            instance_create_layer(_spawn_x, _spawn_y, "Instances_fusibles", obj_fusible_pickup);
                            show_debug_message(">>> FUSIBLE SPAWNEADO EN CAPA 'Instances_fusibles'");
                        } else {
                            instance_create_layer(_spawn_x, _spawn_y, layer, obj_fusible_pickup);
                            show_debug_message(">>> ADVERTENCIA: Capa 'Instances_fusibles' no encontrada.");
                        }
                    }
                }
            }
        }

        // --- D. CAMBIO DE ARMA ---
        if (global.has_taser) {
            if (mouse_wheel_down() || keyboard_check_pressed(ord("2"))) global.equipped_item = 1;
            if (mouse_wheel_up() || keyboard_check_pressed(ord("1"))) global.equipped_item = 0;
        }
        break;

    // -----------------------------------------------------
    // CASO: FINAL (OUTRO)
    // -----------------------------------------------------
    case "OUTRO":
        for (var i = 0; i < confetti_count; i++) {
            var _p = confetti_particles[i];
            _p.y += _p.spd;
            if (_p.y > display_get_gui_height() + 10) {
                _p.y = -10;
                _p.x = irandom(display_get_gui_width());
            }
        }

        if (outro_timer > 0) {
            outro_timer -= 1;
        } else {

            // =====================================================
            // NUEVO: SI TERMINASTE LA NOCHE 4 -> CERRAR EL JUEGO
            // =====================================================
            if (global.current_night >= 4) {
                show_debug_message("FIN DEL JUEGO: Noche 4 completada.");
                game_end();
            } else {
                global.current_night += 1;
                game_restart();
            }
        }
        break;
}
