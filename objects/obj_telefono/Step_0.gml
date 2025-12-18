/// @description Lógica del teléfono (solo suena una vez)

// LOGICA PARA COLGAR (MUTE) - PRIORIDAD ALTA
// Ponemos esto al principio para que funcione incluso si global.telefono_ya_sono es true
if (audio_is_playing(sonido_voz)) {
    if (keyboard_check_pressed(ord("L"))) {
        audio_stop_sound(sonido_voz);
        if (instance_exists(obj_subtitle_controller)) {
            instance_destroy(obj_subtitle_controller);
        }
        show_debug_message("Telefono silenciado con L");
    }
}

// Resetear interacción
puede_interactuar = false;

// VERIFICAR: ¿Ya sonó globalmente? Si sí, no hacer nada
if (global.telefono_ya_sono) {
    exit;
}

// VERIFICAR: ¿Estamos en la noche 1 y el juego ya empezó?
if (global.current_night != 1) {
    exit;
}

// VERIFICAR: ¿El juego ya está activo?
if (!instance_exists(o_game_controller)) {
    exit;
}

if (o_game_controller.visual_state != "GAME") {
    exit;
}

// Si NO está sonando, cuenta regresiva
if (!esta_sonando && !ya_sono_alguna_vez) {
    tiempo_hasta_sonar -= 1;
    
    if (tiempo_hasta_sonar <= 0) {
        esta_sonando = true;
        ya_sono_alguna_vez = true;
        
        sonido_actual = audio_play_sound(snd_telefono_ring, 50, true);
        
        show_debug_message("¡EL TELÉFONO ESTÁ SONANDO! (Primera y única vez)");
    }
}

// Si ESTÁ sonando
if (esta_sonando) {
    // Efecto de vibración
    shake_x = random_range(-shake_intensity, shake_intensity);
    shake_y = random_range(-shake_intensity, shake_intensity);
    
    x = original_x + shake_x;
    y = original_y + shake_y;
    
    // ===== ESTA ES LA PARTE IMPORTANTE =====
    // INTERACCIÓN: Verificar si el jugador está cerca
    if (instance_exists(obj_jugador)) {
        var _dist = point_distance(x, y, obj_jugador.x, obj_jugador.y);
        
        if (_dist < 2000) {
            puede_interactuar = true; // ESTO ACTIVA LA E
            
            // Si presiona E, contestar
            if (keyboard_check_pressed(ord("E"))) {
                esta_sonando = false;
                
                if (audio_is_playing(sonido_actual)) {
                    audio_stop_sound(sonido_actual);
                }
                
                x = original_x;
                y = original_y;
                
                // REPRODUCIR EL AUDIO DE VOZ
                 sonido_voz = audio_play_sound(snd_phone_guy_hello, 100, false);
				 
				 // Crear controlador de subtítulos
var subtitulos = instance_create_depth(0, 0, -9999, obj_subtitle_controller);
subtitulos.audio_referencia = sonido_voz;
                
                show_debug_message("¡Contestaste el teléfono! Reproduciendo mensaje...");
                
                global.telefono_ya_sono = true;
                
                // alarm[0] = 300;
            }
        }
    }
}
