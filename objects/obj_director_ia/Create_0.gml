/// @description Inicializar Directorio

// Mapa para guardar datos: Clave = Objeto, Valor = Struct con datos {room, x, y}
global.ubicaciones = ds_map_create();

// --- CONFIGURACIÓN INICIAL (Solo para empezar) ---
// Aquí registramos dónde empieza cada uno al arrancar el juego.
// IMPORTANTE: Cambia "room_escenario" por el nombre real de tu room inicial.

// Ejemplo: Bonnie empieza en el escenario
var _datos_bonnie = {
    sala: rm_oficina_camaras, // <--- PON AQUÍ TU ROOM REAL
    pos_x: 400,           // Coordenada X inicial (aprox)
    pos_y: 300            // Coordenada Y inicial (aprox)
};
ds_map_add(global.ubicaciones, obj_bonnie_guitarra, _datos_bonnie);

// Repite esto para los otros animatrónicos cuando los tengas
// ds_map_add(global.ubicaciones, obj_chica, {sala: room_escenario, pos_x: 500, pos_y: 300});
