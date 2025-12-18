/// @description Configuración Panel + Efectos + Lógica

// =========================================================
// 1. CONFIGURACIÓN BÁSICA
// =========================================================
image_speed = 0;
interaction_radius = 64; 
mostrar_mensaje = false;

// Estado de los fusibles: 1 = Sano (Visible), 0 = Quemado (Vacío)
fusibles = [1, 1, 1, 1]; 

// =========================================================
// 2. CALIBRACIÓN VISUAL (Pixel Perfect)
// =========================================================
fuse_offset_y = -100;
fuse_start_x  = -60;
fuse_sep      = 40;

// =========================================================
// 3. VARIABLES PARA SISTEMA DE REPARACIÓN (HOLD)
// =========================================================
repair_timer = 0;
repair_time_max = 180;
is_repairing = false;

// =========================================================
// 6. SISTEMA DE MENSAJES DE ADVERTENCIA (HUD)
// (SUBIDO ARRIBA SOLO PARA QUE EXISTA ANTES DE LA FUNCIÓN)
// =========================================================
warning_timer = 0;
warning_duration = 120;
warning_text = "⚠ ADVERTENCIA: ¡FUSIBLE QUEMADO! ⚠";
warning_alpha = 0;

// =========================================================
// 5. FUNCIONES INTERNAS
// (SUBIDAS ARRIBA PARA PODER LLAMARLAS)
// =========================================================
function quemar_fusible_aleatorio() {
    var _sanos = [];
    for (var i = 0; i < 4; i++) {
        if (fusibles[i] == 1) array_push(_sanos, i);
    }
    
    if (array_length(_sanos) > 0) {
        var _elegido = _sanos[irandom(array_length(_sanos) - 1)];
        fusibles[_elegido] = 0; 
        
        // Activar advertencia
        warning_timer = warning_duration;
        
        show_debug_message(">>> FUSIBLE DESTRUIDO EN SLOT: " + string(_elegido));
    } else {
        show_debug_message(">>> INTENTO FALLIDO: Ya no quedan fusibles sanos.");
    }
}

function contar_activos() {
    var _c = 0;
    for (var i = 0; i < 4; i++) _c += fusibles[i];
    return _c;
}

// =========================================================
// 4. QUEMADO INICIAL (SEGÚN DIFICULTAD)
// (SE QUEDA IGUAL, SOLO AHORA YA EXISTE LA FUNCIÓN)
// =========================================================
if (variable_global_exists("start_broken")) {
    var _rotos = global.start_broken;
    repeat(_rotos) {
        quemar_fusible_aleatorio(); 
    }
}
