/// @description Control Blindado de Cámaras

// =========================================================
// 1. SEGURIDAD ELÉCTRICA
// =========================================================
if (global.power_on == false) {
    if (global.en_camaras == true) {
        global.en_camaras = false;
        interferencia = false;
        // audio_play_sound(snd_poweroff, 50, false);
    }
}

// =========================================================
// 2. DETECCIÓN DE APERTURA (FIX DEL BUG)
// =========================================================
// Si las cámaras están activas PERO mi variable de control dice que antes no lo estaban...
if (global.en_camaras && !monitor_was_open) {
    monitor_was_open = true;
    monitor_buffer = 15; // <--- FORZAMOS ESPERA DE 15 FRAMES (0.25 segs)
}
// Si las cámaras se cierran, reseteamos la variable
else if (!global.en_camaras && monitor_was_open) {
    monitor_was_open = false;
}

// Reducir el buffer si es mayor a 0
if (monitor_buffer > 0) {
    monitor_buffer--;
}

// =========================================================
// 3. LÓGICA DE CÁMARAS (Solo si el buffer llegó a 0)
// =========================================================

// CASO A: MODO MONITOR (Y hay luz)
if (global.en_camaras && global.power_on) {

    // --- INTERFERENCIA ---
    if (!interferencia) {
        if (random(100) < 0.8) {
            interferencia = true;
            tiempo_interferencia = irandom_range(5, 15); 
        }
    } else {
        tiempo_interferencia--;
        if (tiempo_interferencia <= 0) interferencia = false;
    }

    // --- SOLO PERMITIR INPUT SI EL BUFFER TERMINÓ ---
    if (monitor_buffer <= 0) {
        
        // ------------------------------------------------
        // CAMBIO DE CÁMARA (USANDO A / D o Flechas)
        // ------------------------------------------------
        var _move = 0;
        
        // Ahora es seguro usar A y D porque el jugador está congelado
        if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) _move = 1;
        if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left))  _move = -1;

        if (_move != 0) {
            camara_actual += _move;

            // Loop infinito
            if (camara_actual >= total_camaras) camara_actual = 0;
            if (camara_actual < 0) camara_actual = total_camaras - 1;
            
            // Opcional: Sonido de cambio
            // audio_play_sound(snd_switch, 10, false);
        }

        // ------------------------------------------------
        // SALIDA MANUAL (TECLA E)
        // ------------------------------------------------
        if (keyboard_check_pressed(ord("E"))) {
            global.en_camaras = false;
            // audio_play_sound(snd_monitor_close, 10, false);
        }
    }

    // FIJAR VISTA (Siempre, para evitar temblores)
    camera_set_view_pos(view_camera[0], coords_camaras[camara_actual][0], coords_camaras[camara_actual][1]);

} 

// CASO B: MODO JUGADOR
else {
    // Lógica de seguir al jugador
    if (instance_exists(obj_jugador)) {
        // Detectar en qué zona (habitación) está el jugador
         for (var i = 0; i < array_length(zonas_juego); i++) {
            var _zx = zonas_juego[i][0];
            var _zy = zonas_juego[i][1];
            
            // Rectángulo de detección de zona (Ajustar tamaño según tus Rooms)
            if (point_in_rectangle(obj_jugador.x, obj_jugador.y, _zx, _zy, _zx + 3200, _zy + 2000)) {
                camera_set_view_pos(view_camera[0], _zx, _zy);
                break; 
            }
        }
    }
}