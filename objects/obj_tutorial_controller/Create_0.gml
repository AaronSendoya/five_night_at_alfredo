/// @description Configuración del Tutorial

// ===================================================
// INICIALIZAR TODAS LAS VARIABLES PRIMERO
// ===================================================
tutorial_active = true;
tutorial_step = 0; // Paso actual (0 = primera pantalla)
total_steps = 8; // Total de pantallas

// Control de avance
can_advance = true;
advance_delay = 0;

// Fondo oscuro
fade_alpha = 0;

// Posiciones Y de los sprites (para centrarlos mejor)
sprite_y_offset = -200; // Cuánto arriba del centro poner el sprite

// ===================================================
// TEXTOS PARA CADA PANTALLA
// ===================================================
tutorial_texts = [];
tutorial_texts[0] = "BIENVENIDO A CINCO NOCHES CON ALFREDO\n\nPresiona ESPACIO para continuar";
tutorial_texts[1] = "Usa WASD o las FLECHAS para moverte";
tutorial_texts[2] = "Presiona SHIFT para correr\n\nCorrer gasta STAMINA\nSi se agota, entraras en COOLDOWN";
tutorial_texts[3] = "SISTEMA ELECTRICO\n\nCada 60-70 segundos, un fusible puede quemarse\nSin fusibles, las luces se apagan";
tutorial_texts[4] = "REPARAR FUSIBLES\n\n1. Encuentra fusibles en el mapa\n2. Recogelos con la tecla E\n3. Ve al Panel de Fusibles\n4. Presiona E para instalarlos";
tutorial_texts[5] = "ESCONDERSE\n\nBusca LOCKERS (armarios)\nPresiona E cerca de uno para esconderte\nLos animatronicos NO te veran";
tutorial_texts[6] = "SISTEMA DE CAMARAS\n\nAcercate al PC en la oficina\nPresiona E para abrir el monitor\nUsa FLECHAS para cambiar de camara";
tutorial_texts[7] = "OBJETIVO\n\nSobrevive de 12:00 AM a 6:00 AM\nEvita a los animatronicos\nManten las luces encendidas\n\nBUENA SUERTE!";

// ===================================================
// SPRITES PARA CADA PANTALLA
// ===================================================
tutorial_sprites = [];
tutorial_sprites[0] = noone; // Pantalla de bienvenida sin sprite
tutorial_sprites[1] = sp_tutorial_movement; // Teclas de movimiento
tutorial_sprites[2] = sp_tutorial_stamina; // Barra de stamina
tutorial_sprites[3] = sp_fusible_0; // Fusible quemado
tutorial_sprites[4] = sp_fusible_1; // Fusible bueno
tutorial_sprites[5] = sp_tutorial_locker; // Locker
tutorial_sprites[6] = sp_tutorial_camara; // Computadora
tutorial_sprites[7] = noone; // Pantalla final sin sprite