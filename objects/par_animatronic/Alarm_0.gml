/// @description Latido ODM (oportunidad de movimiento)

alarm[0] = irandom_range(odm_min_time, odm_max_time);

// IA apagada o sin dificultad → no hace nada
if (!global.animatronics_active || ai_level <= 0) exit;

// Tirada 0..19
var _roll = irandom(19);

// Si la tirada es menor o igual al nivel de IA (0–20), el hijo decide algo
if (_roll <= ai_level) {
    event_user(0);
}
