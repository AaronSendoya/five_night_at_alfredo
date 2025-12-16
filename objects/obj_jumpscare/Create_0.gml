// Configuración del parpadeo
flash_timer = 0;
image_speed = 0; // Si vas a poner un sprite animado del susto después

// Reproducir sonido de susto (Asegúrate de tener un sonido llamado snd_scream o cámbiale el nombre aquí)
if (audio_exists(snd_jumpscare_1)) {
    audio_play_sound(snd_jumpscare_1, 1000, false);
}

// Tiempo antes de reiniciar (3 segundos = 180 frames a 60fps)
alarm[0] = 180;