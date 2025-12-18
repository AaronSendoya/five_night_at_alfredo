/// @description Control de Cámara (Monitor y Jugador)

// =========================================================
// 1. SEGURIDAD ELÉCTRICA (FORZAR CIERRE)
// =========================================================

// Verificamos si se fue la luz
if (global.power_on == false) {
    
    // Si el jugador tenía el monitor abierto, lo cerramos a la fuerza
    if (global.en_camaras == true) {
        global.en_camaras = false;
        interferencia = false;
        
        // Sonido de apagado (opcional)
        // audio_play_sound(snd_power_down, 50, false);
        
        show_debug_message("¡APAGÓN! CERRANDO SISTEMA DE VIGILANCIA.");
    }
}

// =========================================================
// 2. LÓGICA DE INTERFERENCIA (Solo si hay luz y monitor abierto)
// =========================================================
if (global.en_camaras && global.power_on) {
    if (!interferencia) {
        // Probabilidad de fallo (0.8% por frame)
        if (random(100) < 0.8) {
            interferencia = true;
            tiempo_interferencia = irandom_range(5, 15); 
        }
    } 
    else {
        // Cuenta regresiva de la interferencia
        tiempo_interferencia--;
        if (tiempo_interferencia <= 0) {
            interferencia = false;
        }
    }
}

// =========================================================
// 3. CONTROL DE VISTAS (MODO MONITOR VS JUGADOR)
// =========================================================

// CASO A: ESTAMOS EN LAS CÁMARAS (Y hay luz)
if (global.en_camaras && global.power_on) {
    
    // ------------------------------------------------
    // MODO MONITOR: Viajar con flechas
    // ------------------------------------------------
    if (keyboard_check_pressed(vk_right)) camara_actual++;
    if (keyboard_check_pressed(vk_left)) camara_actual--;
    
    // Loop infinito del array de cámaras
    if (camara_actual >= total_camaras) camara_actual = 0;
    if (camara_actual < 0) camara_actual = total_camaras - 1;

    // Mover vista a la cámara seleccionada
    camera_set_view_pos(view_camera[0], coords_camaras[camara_actual][0], coords_camaras[camara_actual][1]);

} 

// CASO B: MODO JUGADOR (Caminando o sin luz)
else {
    // ------------------------------------------------
    // MODO JUGADOR: Detectar en qué sala estoy
    // ------------------------------------------------
    
    // NOTA: Esta parte se ejecuta si cierras el monitor O si se va la luz.
    // Es vital para que la cámara siga al jugador en la oscuridad.
    
    if (instance_exists(obj_jugador)) {
        for (var i = 0; i < array_length(zonas_juego); i++) {
            var _zx = zonas_juego[i][0];
            var _zy = zonas_juego[i][1];
            
            // Comprobamos si el jugador está dentro de esta zona
            // (Usamos un rectángulo amplio para asegurar detección)
            if (point_in_rectangle(obj_jugador.x, obj_jugador.y, _zx, _zy, _zx + 3200, _zy + 2000)) {
                camera_set_view_pos(view_camera[0], _zx, _zy);
                break; 
            }
        }
    }
}