/// @description IA Chica: Prioridad Absoluta al Sabotaje

// 0. SEGURIDAD
if (!global.animatronics_active || my_ai_level == 0) {
    event_inherited();
    exit;
}

// =================================================================
// ESTADO 1: MODO NORMAL (Esperando Boot y Patrullando)
// =================================================================
if (estado_actual == "NORMAL") {

    // Ejecutar lógica del padre (Maneja el tiempo de espera inicial y patrulla)
    event_inherited(); 

    // --- CORRECCIÓN CRÍTICA: ¿ESTOY DESPIERTA? ---
    // La alarma[0] es la que usa el padre para el 'Boot Time'.
    // Si es mayor a 0, significa que Chica sigue apagada/reiniciándose.
    // NO bajamos el cooldown del sabotaje mientras esté apagada.
    if (alarm[0] > 0) return;

    // Gestión del tiempo de sabotaje
    if (timer_cooldown > 0) {
        timer_cooldown--;
    } 
    else {
        // HORA DE SABOTEAR
        var _panel = instance_nearest(target_x_fixed, target_y_fixed, obj_panel_fusibles);
        
        var _necesita_reparar = false;
        if (_panel != noone) {
            for (var i = 0; i < 4; i++) {
                if (_panel.fusibles[i] == 1) _necesita_reparar = true;
            }
        }

        if (_necesita_reparar) {
            // CALCULAR RUTA
            if (mp_grid_path(grid_ia, path_mission, x, y, target_x_fixed, target_y_fixed, true)) {
                
                estado_actual = "VIAJE";
                sabotage_panel_id = _panel;
                timer_romper = timer_romper_max;
                
                // INICIAR MOVIMIENTO (Prioridad máxima)
                path_start(path_mission, velocidad_mision, path_action_stop, true);
                
                sprite_index = spr_frente; 
                show_debug_message("CHICA: Iniciando Misión de Sabotaje.");
            } 
            else {
                timer_cooldown = 120; // Reintentar pronto si falla el camino
            }
        } else {
            timer_cooldown = timer_cooldown_max; // Panel sano, esperar
        }
    }
}

// =================================================================
// ESTADO 2: MODO VIAJE (Ignora al Padre)
// =================================================================
else if (estado_actual == "VIAJE") {

    depth = -y; 

    // Control de Sprites
    image_speed = 1;
    var _dir = direction;
    if (_dir < 0) _dir += 360;
    if (_dir >= 360) _dir -= 360;

    if (_dir > 45 && _dir <= 135) sprite_index = spr_atras;
    else if (_dir > 135 && _dir <= 225) sprite_index = spr_izquierda;
    else if (_dir > 225 && _dir <= 315) sprite_index = spr_frente;
    else sprite_index = spr_derecha;

    if (!sprite_exists(sprite_index)) sprite_index = spr_frente;

    // Verificar Llegada
    if (path_position == 1) {
        path_end(); 
        if (point_distance(x, y, target_x_fixed, target_y_fixed) < 32) {
            estado_actual = "TRABAJO";
            sprite_index = spr_atras; 
            image_index = 0;
            show_debug_message("CHICA: Llegada al panel confirmada.");
        } else {
            estado_actual = "NORMAL";
            timer_cooldown = 120; 
        }
    }
    exit; // ¡IMPORTANTE! Exit previene que el padre interfiera
}

// =================================================================
// ESTADO 3: MODO TRABAJO (Rompiendo)
// =================================================================
else if (estado_actual == "TRABAJO") {

    speed = 0; 
    depth = -y;
    sprite_index = spr_atras; // Forzar vista al panel
    image_speed = 0.5; 

    if (timer_romper > 0) {
        timer_romper--;
    } 
    else {
        if (instance_exists(sabotage_panel_id)) {
            with (sabotage_panel_id) { quemar_fusible_aleatorio(); }
            show_debug_message("CHICA: ¡Sabotaje completado!");
        }
        estado_actual = "NORMAL";
        sabotage_panel_id = noone;
        timer_cooldown = timer_cooldown_max; 
    }
    exit;
}