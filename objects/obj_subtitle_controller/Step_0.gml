/// @description Actualizar subtítulos

// Verificar si el audio sigue sonando
if (audio_referencia != noone && !audio_is_playing(audio_referencia)) {
    instance_destroy();
    exit;
}

// Calcular tiempo transcurrido en segundos
var tiempo_transcurrido = (current_time - tiempo_inicio) / 1000;

// Actualizar índice del subtítulo actual
for (var i = 0; i < array_length(tiempos); i++) {
    if (tiempo_transcurrido >= tiempos[i]) {
        indice_actual = i;
    }
}

// Fade in del subtítulo
if (alpha_subtitulo < 1) {
    alpha_subtitulo += 0.05;
}