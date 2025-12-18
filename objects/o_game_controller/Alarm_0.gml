/// @description El Despertar
// Activar a los animatrónicos
global.animatronics_active = true;

if (!amb_started) {
    audio_stop_sound(snd_ambience);          
    audio_play_sound(snd_ambience, 0, true); 
    amb_started = true;
}
boot_sequence_done = true;
show_debug_message("SISTEMAS ONLINE: Los animatrónicos ahora pueden moverse.");
// Aquí podrías reproducir un sonido de ambiente o una voz


