/// @description IA Freddy: Intervalos de 30s y Audio Cortado

// 0. SEGURIDAD
if (!global.animatronics_active || my_ai_level == 0) {
    event_inherited();
    exit;
}

if (alarm[0] > 0) {
    event_inherited();
    exit;
}

// =================================================================
// LÓGICA DE EMBESTIDA (RUSH - 6 SEGUNDOS)
// =================================================================

if (is_rushing) {
    // 1. Velocidad Máxima
    chase_speed = speed_rush;
    move_speed  = speed_rush;
    
    if (instance_exists(obj_jugador)) {
        state = "CHASE"; 
    }

    // 2. Cuenta regresiva del ataque
    if (timer_rush_duration > 0) {
        timer_rush_duration--;
    } 
    else {
        // --- ¡TIEMPO FUERA! SILENCIAR Y CALMAR ---
        is_rushing = false;
        
        // 1. CORTAR SONIDO DE GOLPE
        // Esto evita que la risa de 21 segundos siga sonando.
        if (audio_is_playing(snd_freddy_laugh)) {
            audio_stop_sound(snd_freddy_laugh);
        }
        
        // 2. Restaurar velocidad
        chase_speed = speed_stalk;
        move_speed  = speed_stalk;
        
        // 3. Reiniciar intervalo largo (30s aprox)
        timer_attack_cooldown = irandom_range(1500, 2100); 
        
        if (!can_see_player) state = "PATROL";
        
        show_debug_message("FREDDY: Ataque terminado. Silencio.");
    }
}

// =================================================================
// LÓGICA DE ACECHO (ESPERA DE 30 SEGUNDOS)
// =================================================================
else {
    chase_speed = speed_stalk;
    move_speed  = speed_stalk;

    // Cuenta regresiva larga
    if (timer_attack_cooldown > 0) {
        timer_attack_cooldown--;
    } 
    else {
        // --- ¡ACTIVAR ATAQUE! ---
        is_rushing = true;
        timer_rush_duration = timer_rush_duration_max; // 6 segundos
        
        // Reproducir sonido
        if (variable_global_exists("snd_freddy_laugh") || audio_exists(snd_freddy_laugh)) {
             audio_stop_sound(snd_freddy_laugh); // Prevenir solapamiento
             audio_play_sound(snd_freddy_laugh, 100, false); 
        }
        
        show_debug_message("FREDDY: ¡RISA! (Iniciando 6s de furia)");
        
        speed = 0; 
    }
}

// =================================================================
// HERENCIA
// =================================================================
event_inherited();