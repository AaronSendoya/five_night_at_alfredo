/// @description Lógica Principal (Intro -> Juego -> Final)

// ---------------------------------------------------------
// ESTADO 1: INTRODUCCIÓN ("NIGHT X")
// ---------------------------------------------------------
if (visual_state == "INTRO") {
    if (intro_timer > 0) {
        intro_timer -= 1;
    } else {
        visual_state = "GAME";
        alarm[0] = 60; 
    }
    exit;
}

// ---------------------------------------------------------
// ESTADO 2: JUEGO (RELOJ CORRIENDO)
// ---------------------------------------------------------
if (visual_state == "GAME") {
    
    if (game_ended) exit;

    game_timer += delta_time / 1000000;

    var _hours_passed = floor(game_timer / seconds_per_hour);
    var _raw_hour = start_hour + _hours_passed;
    if (_raw_hour > 12) _raw_hour -= 12; 
    current_hour_display = _raw_hour;

    var _seconds_into_hour = game_timer % seconds_per_hour;
    current_minute_display = floor((_seconds_into_hour / seconds_per_hour) * 60);

    // VICTORIA (6:00 AM)
    if (_hours_passed >= end_hour) { 
        game_ended = true;
        current_hour_display = 6;
        current_minute_display = 0;
        
        global.animatronics_active = false;
        visual_state = "OUTRO"; // Pasamos a la celebración
        
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
        _p.y += _p.spd; 
        if (_p.y > display_get_gui_height() + 10) {
            _p.y = -10;
            _p.x = irandom(display_get_gui_width());
        }
    }
    
    // 2. NUEVO: Lógica de paso de nivel
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