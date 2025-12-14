/// @description Inicializar Directorio (LIMPIO)

// Mapa para guardar datos: Clave = Objeto, Valor = Struct con datos {room, x, y}
global.ubicaciones = ds_map_create();

// --- NOTA IMPORTANTE ---
// Como estamos usando la "Opción B" (Auto-Registro),
// NO agregamos a nadie manualmente aquí.
// Simplemente arrastra tus animatrónicos al mapa en el editor de GameMaker.
// Ellos se registrarán solos al iniciar el juego.