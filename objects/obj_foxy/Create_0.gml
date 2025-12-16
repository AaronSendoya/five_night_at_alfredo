/// @description Configuración: Depredador de la Oscuridad

// =========================================================================
// 1. CONECTAR CON EL CEREBRO GLOBAL (IGNORANDO BOOT TIME)
// =========================================================================
if (variable_global_exists("ai_level_rufus")) {
    my_ai_level = global.ai_level_rufus; // Carga la dificultad de la noche (ej: 10)
    
    // REGLA DE ORO DE FOXY:
    // Aunque el juego diga que espere 50 segundos (global.boot_rufus),
    // Foxy lo ignora y se pone en 0. Su "reloj" es la oscuridad.
    my_boot_time = 0; 
} else {
    my_ai_level = 0;
    my_boot_time = 0;
}

// =========================================================================
// 2. INICIALIZAR PADRE
// =========================================================================
event_inherited(); 

// =========================================================================
// 3. SPRITES (DESPUÉS del padre para evitar borrado)
// =========================================================================
spr_frente    = sp_foxy_caminar_frente;
spr_atras     = sp_foxy_caminar_atras;
spr_derecha   = sp_foxy_caminar_derecha;
spr_izquierda = sp_foxy_caminar_izquierda;

// =========================================================================
// 4. ESTADÍSTICAS
// =========================================================================
velocidad_normal = 2.6; 
velocidad_caza   = 4.5; 

move_speed  = velocidad_normal;
chase_speed = velocidad_caza;

// Definimos rango de visión para evitar el Crash del Draw
view_dist = 300;
fov_angle = 120;

// =========================================================================
// 5. LÓGICA DE RETORNO (CUEVA)
// =========================================================================
home_x = xstart;
home_y = ystart;

// Path exclusivo para volver a casa
path_return = path_add();
path_set_kind(path_return, 1); 
path_set_precision(path_return, 8);

// =========================================================================
// 6. ESTADO INICIAL (VISIBILIDAD CORREGIDA)
// =========================================================================
// ¡AQUÍ ESTABA EL ERROR DE INVISIBILIDAD!
// Debe empezar visible para que lo veas quieto en su sitio.
visible = true; 
state = "IDLE";