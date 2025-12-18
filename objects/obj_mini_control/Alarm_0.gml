/// @description Generar Pizza

if (!game_over) {
    var _x_random = irandom_range(30, room_width - 30);
    
    // CAMBIO: Usamos 'depth' en lugar de 'layer'. 
    // El -100 asegura que la pizza se dibuje POR ENCIMA del fondo.
    instance_create_depth(_x_random, -20, -100, obj_mini_pizza);

    // Reiniciar alarma
    alarm[0] = irandom_range(30, 90);
}