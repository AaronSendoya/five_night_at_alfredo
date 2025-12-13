/// @description Cambiar color
// Elegir nuevo color al azar
color_actual = colores[irandom(array_length(colores) - 1)];

// Reiniciar alarma (con un poco de variedad para que no sean todos iguales)
alarm[0] = 10 + irandom(20);