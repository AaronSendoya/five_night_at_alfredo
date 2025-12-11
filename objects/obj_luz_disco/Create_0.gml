/// @description Configurar colores y ritmo

// Lista de colores de neón
colores = [c_red, c_lime, c_aqua, c_fuchsia, c_yellow, c_orange];

// Elegir un color inicial
color_actual = colores[irandom(array_length(colores) - 1)];

// Tamaño del foco
radio = 100; // Qué tan grande es la bola de luz

// Velocidad del parpadeo
alarm[0] = 15; // Cambia cada 15 frames (1/4 de segundo)