/// @description Dirección, Altura y Batería

// 1. SI NO TIENES LINTERNA, SALIR
if (!has_flashlight) exit; 

if (instance_exists(obj_jugador)) {
    // --- CORRECCIÓN DE POSICIÓN ---
    // x: Igual que el jugador
    // y: Restamos 35 o 40 pixeles para subir al pecho/cabeza
    x = obj_jugador.x;
    y = obj_jugador.y - 35; 
    
    // --- CORRECCIÓN DE DIRECCIÓN (Sprites) ---
    var _s_index = obj_jugador.sprite_index;
    
    // Asumiendo que tu 'spr_light_beam' apunta hacia ARRIBA en el editor:
    if (_s_index == sp_shadow_caminar_derecha)      beam_angle = 270; // Derecha
    else if (_s_index == sp_shadow_caminar_izquierda) beam_angle = 90;  // Izquierda
    else if (_s_index == sp_shadow_caminar_atras)     beam_angle = 0;   // Arriba
    else if (_s_index == sp_shadow_caminar_frente)    beam_angle = 180; // Abajo (Default)
    
} else {
    is_on = false;
    exit;
}

// 2. SISTEMA DE RECARGA (DINAMO)
if (keyboard_check(key_crank)) {
    is_cranking = true;
    is_on = false; 
    
    if (battery_level < battery_max) battery_level += charge_rate;
    else battery_level = battery_max;
    
} else {
    is_cranking = false;
}

// 3. ENCENDER / APAGAR
if (keyboard_check_pressed(key_toggle) && !is_cranking) {
    if (battery_level > 0) is_on = !is_on;
}

// 4. CONSUMO Y LUMINOSIDAD
if (is_on && battery_level > 0) {
    battery_level -= drain_rate;
    var _pct = battery_level / battery_max;
    
    // Intensidad (Alpha)
    if (_pct > 0.5) light_alpha = 1;     // Luz fuerte
    else if (_pct > 0.15) light_alpha = 0.6; // Luz media
    else {
        // Parpadeo crítico
        if (random(100) < 15) light_alpha = random_range(0.1, 0.3); 
        else light_alpha = 0.4;
    }
} else {
    is_on = false; 
    light_alpha = 0;
}

// DETECTAR CUANDO LA BATERÍA MUERE
if (battery_level <= 0) {
    if (!battery_was_empty) {
        // Justo en este frame se acabó la batería
        msg_timer = msg_duration; // Activamos el mensaje
        battery_was_empty = true;
    }
} else {
    // Si tiene carga, reseteamos el detector
    battery_was_empty = false;
    // Si recarga, quitamos el mensaje inmediatamente
    msg_timer = 0; 
}

// Bajar el temporizador del mensaje
if (msg_timer > 0) msg_timer--;