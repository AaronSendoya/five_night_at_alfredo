/// @description Chequear Fin del Juego
if (!game_over) {
    // Condición de Victoria: Llegar a 100 puntos
    if (score >= 100) {
        game_over = true;
        alarm[1] = 120; // Esperar 2 segundos antes de salir
    }
    // Opcional: Condición de Derrota por vidas
    /*
    if (vidas <= 0) {
        game_over = true;
        alarm[1] = 120;
    }
    */
}