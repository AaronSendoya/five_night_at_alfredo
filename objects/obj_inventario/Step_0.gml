/// @description Abrir/Cerrar con TAB

if (keyboard_check_pressed(vk_tab)) {
    inventory_visible = !inventory_visible;
    
    // Opcional: Reproducir sonido de cierre/apertura
    // audio_play_sound(snd_zipper, 10, false);
}