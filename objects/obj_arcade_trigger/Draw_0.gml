/// @description Dibujar la "E" 

// 1. Calculamos distancia con el jugador
var _distancia = distance_to_object(obj_jugador);

// 2. Si está cerca (menos de 40 pixeles)
if (_distancia < 40) {
   
    // Animación de flotar suave
    var _flotar = sin(current_time / 200) * 3; 
   
    // --- AQUÍ ESTÁ EL CAMBIO DE TAMAÑO ---
    // Hemos cambiado los '2' por '3' para hacerlo el TRIPLE de grande.
    // Puedes probar con 2.5, 4, etc., hasta que te guste el tamaño.
    draw_sprite_ext(sp_tecla_e, 0, x, y - 70 + _flotar, 3, 3, 0, c_white, 1);
   
}