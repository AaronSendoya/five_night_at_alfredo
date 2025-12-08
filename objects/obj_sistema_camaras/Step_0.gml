if (global.en_camaras) {
    // Cambiar cámara con flechas Derecha/Izquierda
    if (keyboard_check_pressed(vk_right)) {
        camara_actual += 1;
        if (camara_actual >= total_camaras) camara_actual = 0; // Volver a la primera
    }

    if (keyboard_check_pressed(vk_left)) {
        camara_actual -= 1;
        if (camara_actual < 0) camara_actual = total_camaras - 1; // Ir a la última
    }
}