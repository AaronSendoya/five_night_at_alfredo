/// @description Lógica Principal (Intro -> Juego -> Final)

// ESTADO 1: INTRODUCCIÓN ("NIGHT X")
if (visual_state == "INTRO") {
    if (intro_timer > 0) {
        intro_timer -= 1;
    } else {
        visual_state = "GAME";
        alarm[0] = 60; 
    }
    exit;
}

// ESTADO 0: TUTORIAL (Solo Noche 1)
if (visual_state == "TUTORIAL") {
    // El obj_tutorial_controller maneja todo
    // Cuando termine, cambiará el estado a "INTRO"
    exit;
}

// ESTADO 2: JUEGO EN CURSO (GAME)
if (visual_state == "GAME") {
    
    if (game_ended) exit;

    // 1. RELOJ DEL JUEGO
    game_timer += delta_time / 1000000;

    var _hours_passed = floor(game_timer / seconds_per_hour);
    
    // =========================================================
    // --- CORRECCIÓN: VERIFICAR FINAL DE LA NOCHE (6 AM) ---
    // =========================================================
    // Si empezamos a las 12, necesitamos que pasen 6 horas para ganar.
    // (end_hour es 6, start_hour es 12. Diferencia = 6 horas).
    
    if (_hours_passed >= 6) { 
        visual_state = "OUTRO";       // Cambiar a pantalla de victoria
        game_ended = true;            // Bloquear lógica de juego
        global.animatronics_active = false; // Apagar animatrónicos
        
        // Destruir cualquier alarma pendiente para que no salten sustos en la victoria
        with(par_animatronic) { alarm[0] = -1; state = "IDLE"; }
        
        exit; // Dejar de ejecutar este frame
    }
    // =========================================================

    // Cálculo visual del reloj
    var _raw_hour = start_hour + _hours_passed;
    if (_raw_hour > 12) _raw_hour -= 12; 
    current_hour_display = _raw_hour;

    var _seconds_into_hour = game_timer % seconds_per_hour;
    current_minute_display = floor((_seconds_into_hour / seconds_per_hour) * 60);

    // 2. SISTEMA DE FALLOS ELÉCTRICOS (TU LÓGICA)
    if (global.animatronics_active) { // Solo si la noche ya empezó
        
        fuse_system_timer += delta_time / 1000000; // Sumar segundos reales
        
        // Usamos la variable global cargada desde la configuración de la noche
        if (fuse_system_timer >= global.fuse_interval) {
            
            // IMPORTANTE: Resetear el timer inmediatamente para que no espamee
            fuse_system_timer = 0; 
            
            // Probabilidad de fallo
            if (random(100) < global.fuse_chance) {
                
                show_debug_message("¡INTENTO DE QUEMA DE FUSIBLE!"); // Solo debe salir 1 vez
                
                // Ordenar al panel que destruya uno
                if (instance_exists(obj_panel_fusibles)) {
                    with(obj_panel_fusibles) {
                        quemar_fusible_aleatorio();
                    }
                }
            } else {
                 show_debug_message("¡Suerte! El sistema eléctrico resistió esta vez.");
            }
        }
    }
}

// ESTADO 3: FINAL (CONFETI Y TRANSICIÓN)
if (visual_state == "OUTRO") {
    // ... (Tu código de confeti original sigue aquí igual) ...
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
    } 
    else {
        global.current_night += 1; 
        game_restart(); // O room_goto(rm_menu); según tu flujo
    }
}