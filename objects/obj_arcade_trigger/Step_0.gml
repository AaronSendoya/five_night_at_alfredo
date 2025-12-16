/// @description Detectar tecla E y viajar

// 1. Vigilar si el jugador está cerca
// Usamos la misma distancia que en el evento Dibujar (40) para que coincida visualmente
var _distancia = distance_to_object(obj_jugador);

if (_distancia < 40) {
    
    // 2. Si está cerca, escuchamos si presiona la tecla E
    if (keyboard_check_pressed(ord("E"))) {
        
        // ... (dentro del if keyboard_check_pressed ...)

    // 1. Guardar posición del jugador (esto ya lo tenías)
    global.jugador_return_x = obj_jugador.x;
    global.jugador_return_y = obj_jugador.y + 20;
    
    // 2. ¡NUEVO! Guardar el tiempo actual del juego
    // Verificamos que el controlador exista para no dar error
    if (instance_exists(o_game_controller)) {
        global.saved_game_timer = o_game_controller.game_timer;
    } else {
        global.saved_game_timer = 0;
    }

    // 3. Ir al minijuego
    room_goto(rm_minijuego_pizza);

// ...
        
        // A. Guardamos dónde estaba el jugador (para volver luego)
        // Accedemos a las coordenadas del jugador usando 'obj_jugador.x'
        global.jugador_return_x = obj_jugador.x;
        global.jugador_return_y = obj_jugador.y + 20; 
        
        // B. ¡Nos vamos al minijuego!
        room_goto(rm_minijuego_pizza);
    }
}