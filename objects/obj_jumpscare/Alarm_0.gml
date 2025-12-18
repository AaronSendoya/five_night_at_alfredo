// Restar vida
global.player_lives -= 1;

// Verificar si quedan vidas
if (global.player_lives > 0) {
    // Aún tiene vidas: Solo reinicia la sala actual (respawn)
    room_restart();
} else {
    // Se acabaron las vidas: Game Over o Reiniciar Noche completa
    global.player_lives = 3; // Resetear vidas para el reintento
    room_restart(); // O room_goto(rm_game_over) si tienes una
}