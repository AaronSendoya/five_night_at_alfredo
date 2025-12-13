/// @description Lógica de Interacción

// Si estamos cerca (menos de 60px)
if (distance_to_object(obj_jugador) < 160) {
    
    mostrar_mensaje = true; // 
    
    // Permitir pulsar E
    if (keyboard_check_pressed(ord("E"))) {
        global.en_camaras = !global.en_camaras; 
    }
    
} else {
    // Si nos alejamos
    mostrar_mensaje = false; // <--- Ocultamos el mensaje de texto
    
    // Si te alejas mucho, apagar cámaras automáticamente
    if (global.en_camaras) global.en_camaras = false; 
}