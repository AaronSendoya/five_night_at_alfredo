/// @description Regresar al Arcade (Victoria)

// 1. Configurar coordenadas de regreso
global.jugador_return_x = 1843;
global.jugador_return_y = 2302;

// 2. ACTIVAR EL SALTO DE INTRO (¡Esto es lo vital!)
global.skip_intro = true;

// 3. Ahora sí, volvemos a la oficina
room_goto(rm_oficina_camaras);