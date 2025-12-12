/// @description Configuración inicial Bongo (Bonnie Guitarra)

event_inherited(); // Create del padre

// Escala base (por si luego la usas)
escala_base_x = image_xscale;
escala_base_y = image_yscale;

estado_demo = "baile";

image_speed = 0.5;

// Nivel de IA desde controlador
ai_level = variable_global_exists("ai_level_bongo") ? global.ai_level_bongo : 5;

// Bongo más rápido
move_speed = 3;

// Hogar
home_x = x;
home_y = y;

// Info sobre jugador
has_seen_player = false;

// Zona de patrulla (todo el room menos bordes)
patrol_min_x = 64;
patrol_max_x = room_width  - 64;
patrol_min_y = 64;
patrol_max_y = room_height - 64;

patrol_timer = 0;
