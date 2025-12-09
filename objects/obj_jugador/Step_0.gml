/// @description Movimiento, Colisiones y Sprites

// --- 1. CONTROLES (Flechas o WASD) ---
var _derecha = keyboard_check(vk_right) or keyboard_check(ord("D"));
var _izquierda = keyboard_check(vk_left) or keyboard_check(ord("A"));
var _abajo = keyboard_check(vk_down) or keyboard_check(ord("S"));
var _arriba = keyboard_check(vk_up) or keyboard_check(ord("W"));

// --- 2. CALCULAR VELOCIDAD ---
// (1 - 0) = 1 (derecha), (0 - 1) = -1 (izquierda), etc.
var _hspd = (_derecha - _izquierda) * velocidad;
var _vspd = (_abajo - _arriba) * velocidad;

// --- 3. COLISIÓN HORIZONTAL (Con obj_pared) ---
// Si vamos a chocar horizontalmente...
if (place_meeting(x + _hspd, y, obj_pared)) {
    // ...nos movemos píxel a píxel hasta tocar la pared
    while (!place_meeting(x + sign(_hspd), y, obj_pared)) {
        x = x + sign(_hspd);
    }
    _hspd = 0; // Detener velocidad
}
x = x + _hspd; // Aplicar movimiento

// --- 4. COLISIÓN VERTICAL (Con obj_pared) ---
// Si vamos a chocar verticalmente...
if (place_meeting(x, y + _vspd, obj_pared)) {
    while (!place_meeting(x, y + sign(_vspd), obj_pared)) {
        y = y + sign(_vspd);
    }
    _vspd = 0; // Detener velocidad
}
y = y + _vspd; // Aplicar movimiento

// --- 5. CAMBIO DE SPRITES (Tus nombres exactos) ---

// Si se está moviendo (velocidad distinta de 0)
if (_hspd != 0 || _vspd != 0) {
    image_speed = 1; // Activar animación de pasos
    
    if (_vspd > 0) { // Moviéndose ABAJO
        sprite_index = sp_shadow_caminar_frente;
    }
    else if (_vspd < 0) { // Moviéndose ARRIBA
        sprite_index = sp_shadow_caminar_atras;
    }
    else if (_hspd > 0) { // Moviéndose DERECHA
        sprite_index = sp_shadow_caminar_derecha;
    }
    else if (_hspd < 0) { // Moviéndose IZQUIERDA
        sprite_index = sp_shadow_caminar_izquierda;
    }
} else {
    // Si no se mueve, detener la animación (se queda en el frame 0)
    image_speed = 0;
    image_index = 0; 
}