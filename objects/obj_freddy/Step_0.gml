/// @description Lógica de Estados (Baile vs Caminar)

// --- MODO 1: BAILE EN EL ESCENARIO ---
if (estado == "baile") {
    
    // AQUÍ PEGAS TU CÓDIGO ROBÓTICO QUE HICIMOS ANTES:
    var _velocidad = 300;
    var _tic_tac = floor(current_time / _velocidad);

    if (_tic_tac % 2 == 0) {
        image_angle = 5; 
    } else {
        image_angle = -5;
    }
    
    // Mantener tamaño gigante
    image_xscale = escala_base_x;
    image_yscale = escala_base_y;
}

// --- MODO 2: CAMINAR / PERSEGUIR (Futuro) ---
else if (estado == "caminar") {
    
    // Cuando hagamos la IA de movimiento, pondremos el código aquí.
    // Por ahora, nos aseguramos de que NO esté inclinado
    image_angle = 0; 
    
    // Aquí pondrías: mp_potential_step(...) o tu lógica de movimiento
}