/// @description Configuración Zonas y Cámaras

global.en_camaras = false;
camara_actual = 0;

monitor_buffer = 0; 
monitor_was_open = false; // Para detectar cuándo recién se abrió

// --- 1. LISTA DE CÁMARAS (Para el monitor) ---
// Estas son las que ves cuando pulsas E
coords_camaras = [];
coords_camaras[0] = [3071, 0];    // Comedor
coords_camaras[1] = [3071, 1663]; // Mantenimiento
coords_camaras[2] = [0, 5055];    // Cocina
coords_camaras[3] = [0, 1663];    // Arcade
coords_camaras[4] = [2975, 3360]; // Almacen
coords_camaras[5] = [0, 3296];    // Escenario
coords_camaras[6] = [2979, 5056];    // Escenario Atras
total_camaras = array_length(coords_camaras);


// --- 2. LISTA DE ZONAS DE JUEGO (Para el jugador) ---
// Aquí definimos dónde debe ponerse la cámara cuando caminas.
// Incluimos la OFICINA (0,0) y todas las demás.
zonas_juego = [];

// [X, Y] de la esquina superior izquierda de cada "isla"
zonas_juego[0] = [0, 0];       // Oficina
zonas_juego[1] = [3071, 0];    // Comedor
zonas_juego[2] = [3071, 1663]; // Mantenimiento
zonas_juego[3] = [0, 5055];    // Cocina
zonas_juego[4] = [0, 1663];    // Arcade
zonas_juego[5] = [2975, 3360]; // Almacen
zonas_juego[6] = [0, 3296];    // Escenario
zonas_juego[7] = [2979, 5056];    // Escenario atras

// Tamaño aproximado de tus salas (ancho y alto de la pantalla)
// Esto sirve para saber si el jugador está dentro.
ancho_sala = 1366; // Ajusta esto al ancho de tu Viewport (ej. 1366 o 1280)
alto_sala = 768;   // Ajusta esto al alto de tu Viewport (ej. 768 o 720)

// Variable para animar el shader de estática
tiempo_shader = 0;

// --- SISTEMA DE INTERFERENCIA (GLITCH) ---
interferencia = false;      // ¿Se cortó la señal?
tiempo_interferencia = 0;   // Cuánto dura el corte
