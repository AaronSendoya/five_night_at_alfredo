/// @description Lógica Principal (Intro -> Juego -> Final)

// ---------------------------------------------------------
// ESTADO 1: INTRODUCCIÓN ("NIGHT X")
// ---------------------------------------------------------
if (visual_state == "INTRO") {
    if (intro_timer > 0) {
        intro_timer -= 1;
    } else {
        // ¡FIN DE LA INTRO! EMPIEZA EL JUEGO
        visual_state = "GAME";
        
        // Activamos la alarma que enciende la lógica de los animatrónicos
        // Le damos 60 frames (1 seg) extra para que no sea tan brusco
        alarm[0] = 60; 
    }
    // IMPORTANTE: DETENER EL CÓDIGO AQUÍ.
    // Mientras estamos en la intro, el reloj del juego NO avanza.
    exit;
}

// ---------------------------------------------------------
// ESTADO 2: JUEGO EN CURSO (GAME)
// ---------------------------------------------------------
if (visual_state == "GAME") {
    
    // Si el juego ya terminó (ganaste o perdiste), no calculamos tiempo
    if (game_ended) exit;

    // 1. AUMENTAR EL TIEMPO
    game_timer += delta_time / 1000000;

    // 2. CALCULAR HORA Y MINUTOS
    var _hours_passed = floor(game_timer / seconds_per_hour);
    var _raw_hour = start_hour + _hours_passed;
    if (_raw_hour > 12) _raw_hour -= 12; 
    current_hour_display = _raw_hour;

    var _seconds_into_hour = game_timer % seconds_per_hour;
    current_minute_display = floor((_seconds_into_hour / seconds_per_hour) * 60);

    // 3. CHEQUEO DE VICTORIA (6 AM)
    if (_hours_passed >= end_hour) { 
        game_ended = true;
        current_hour_display = 6;
        current_minute_display = 0;
        
        // APAGADO DE EMERGENCIA
        global.animatronics_active = false;
        
        // --- SEGURIDAD VENTILACIÓN (NUEVO) ---
        // Si ganaste escondido, forzamos la aparición para evitar bugs
        global.player_hidden = false; 
        if (instance_exists(obj_jugador)) {
            obj_jugador.visible = true;
        }
        if (instance_exists(obj_vent_ui)) {
            instance_destroy(obj_vent_ui); // Cerrar mapa si estaba abierto
        }

        // ACTIVAR OUTRO VISUAL
        visual_state = "OUTRO";
        
        show_debug_message("¡6:00 AM! Noche completada.");
    }
}

// ---------------------------------------------------------
// ESTADO 3: FINAL (CONFETI Y TRANSICIÓN)
// ---------------------------------------------------------
if (visual_state == "OUTRO") {
    
    // 1. Mover confeti
    for (var i = 0; i < confetti_count; i++) {
        var _p = confetti_particles[i];
        
        // Mover hacia abajo
        _p.y += _p.spd; 
        
        // Si sale de la pantalla, vuelve arriba (loop)
        if (_p.y > display_get_gui_height() + 10) {
            _p.y = -10;
            _p.x = irandom(display_get_gui_width());
        }
    }
    
    // 2. Lógica de paso de nivel
    if (outro_timer > 0) {
        outro_timer -= 1; // Esperamos 5 segundos viendo el confeti
    } 
    else {
        // ¡TIEMPO CUMPLIDO! PASAMOS A LA SIGUIENTE NOCHE
        
        global.current_night += 1; // Aumentar noche (1 -> 2)
        
        // Reiniciamos la sala. 
        // Al reiniciar, el Create se ejecutará de nuevo, cargará la noche nueva
        // y mostrará la INTRO de la "NIGHT 2".
        room_restart(); 
    }
}