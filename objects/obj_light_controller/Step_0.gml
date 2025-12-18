/// @description LÓGICA MAESTRA DE ENERGÍA

// 1. Obtener Referencias (Optimizado)
if (panel_ref == noone) panel_ref = instance_find(obj_panel_fusibles, 0);
if (switch_ref == noone) switch_ref = instance_find(obj_switch_general, 0);

// 2. Lógica de Energía
if (instance_exists(panel_ref) && instance_exists(switch_ref)) {
    
    var _switch_on = switch_ref.is_on;
    var _active_fuses = panel_ref.contar_activos(); // Función que creamos en el panel
    
    // --- ESTADO 1: APAGADO MANUAL ---
    if (!_switch_on) {
        global.power_on = false;
        global.lights_flickering = false;
    }
    
    // --- ESTADO 2: SWITCH ENCENDIDO ---
    else {
        // CASO A: TODO BIEN (4 Fusibles)
        if (_active_fuses == 4) {
            global.power_on = true;
            global.lights_flickering = false;
        }
        // CASO B: FALLO PARCIAL (3 Fusibles) -> Parpadeo
        else if (_active_fuses == 3) {
            global.power_on = true; 
            global.lights_flickering = true;
        }
        // CASO C: FALLO CRÍTICO (2 o menos) -> APAGÓN
        else {
            global.power_on = false;
            global.lights_flickering = false;
            
            // Aquí podrías forzar un sonido de alarma baja
        }
    }
}
// Fallback por si no existen los objetos (Debug)
else {
    global.power_on = true; 
}	

// =========================================================
// SFX APAGÓN (1 vez por apagón + se corta al volver energía)
// =========================================================

// Si pasa de ON -> OFF: reproducir 1 vez
if (power_prev && !global.power_on) {
    if (!blackout_played) {
        audio_play_sound(snd_power_out, 5, false); // NO loop
        blackout_played = true;
    }
}

// Si pasa de OFF -> ON: cortar ese sonido (si aún suena) y resetear
if (!power_prev && global.power_on) {
    audio_stop_sound(snd_power_out);
    blackout_played = false;        
}

// Actualizar estado anterior
power_prev = global.power_on;
