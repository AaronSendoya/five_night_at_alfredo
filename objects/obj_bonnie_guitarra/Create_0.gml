/// @description Configurar Bonnie

// 1. DEFINIR IDENTIDAD
// Protección contra crash si el controller no cargó primero
if (variable_global_exists("ai_level_bongo")) {
    my_ai_level  = global.ai_level_bongo;
    my_boot_time = global.boot_bongo; // NUEVO: Enlazamos el tiempo de espera
} else {
    my_ai_level  = 0;
    my_boot_time = 0;
}

// 2. Ejecutar lógica del Padre
event_inherited(); 

// 3. Definir los sprites específicos de Bonnie
spr_frente = sp_bonnie_caminar_frente_guitarra;
spr_atras = sp_bonnie_caminar_atras_guitarra;
spr_derecha = sp_bonnie_caminar_derecha_guitarra;
spr_izquierda = sp_bonnie_caminar_izquierda_guitarra;

// 4. Ajustes de personalidad
vision_range = 990;