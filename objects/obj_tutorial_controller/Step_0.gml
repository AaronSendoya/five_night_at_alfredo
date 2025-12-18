/// @description Lógica de Avance

if (tutorial_active) {
    // Bloquear movimiento del jugador
    if (instance_exists(obj_jugador)) {
        obj_jugador.puede_moverse = false;
    }
    
    // Detectar ESPACIO para avanzar
    if (keyboard_check_pressed(vk_space) && can_advance) {
        tutorial_step++;
        can_advance = false;
        advance_delay = 15; // 15 frames de delay
        
        // Si terminamos el tutorial
        if (tutorial_step >= total_steps) {
            tutorial_active = false;
            
            // Desbloquear jugador
            if (instance_exists(obj_jugador)) {
                obj_jugador.puede_moverse = true;
            }
            
            // Activar el Game Controller para que empiece la intro
            if (instance_exists(o_game_controller)) {
                o_game_controller.visual_state = "INTRO";
                o_game_controller.intro_timer = 180;
            }
            
            // Destruir este objeto
            instance_destroy();
        }
    }
    
    // Cooldown del botón
    if (advance_delay > 0) {
        advance_delay--;
        if (advance_delay <= 0) {
            can_advance = true;
        }
    }
    
    // Fade in
    if (fade_alpha < 1) {
        fade_alpha += 0.05;
    }
}