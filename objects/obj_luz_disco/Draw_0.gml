/// @description Dibujar el foco de luz

// 1. Activar modo "Luz Brillante" (Additive)
gpu_set_blendmode(bm_add);

// 2. Dibujar un círculo difuminado
// x,y: Posición
// radio: Tamaño
// color_actual: El centro es del color de la luz
// c_black: El borde es negro (transparente en modo aditivo)
// false: No es solo contorno, es relleno
draw_circle_color(x, y, radio, color_actual, c_black, false);

// 3. Volver a la normalidad (¡Vital!)
gpu_set_blendmode(bm_normal);