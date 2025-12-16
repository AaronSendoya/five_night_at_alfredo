/// @description Detener sonido al destruir

if (audio_is_playing(sonido_actual)) {
    audio_stop_sound(sonido_actual);
}