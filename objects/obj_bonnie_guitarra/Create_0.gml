/// @description Configurar Bonnie

// 1. Ejecutar código del padre (Crear grid, variables, etc.)
event_inherited(); 

// 2. Definir los sprites específicos de Bonnie (según tu imagen)
spr_frente = sp_bonnie_caminar_frente_guitarra;
spr_atras = sp_bonnie_caminar_atras_guitarra;
spr_derecha = sp_bonnie_caminar_derecha_guitarra;
spr_izquierda = sp_bonnie_caminar_izquierda_guitarra;

// 3. Ajustes de personalidad (IA Específica)
// Ejemplo: Bonnie podría ser más rápido o ver menos
move_speed = 1.9;
chase_speed = 9.0;
vision_range = 990; // Ve un poco más lejos