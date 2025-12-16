/// @description Controlador Maestro de Luz

global.power_on = true;
global.lights_flickering = false;
darkness_alpha = 0.85; // Ajusta qué tan oscuro es el cuarto (0.95 es muy oscuro)

// Creamos la variable para la superficie (lienzo de sombras)
light_surface = -1;

// Referencias
panel_ref = noone;
switch_ref = noone;

// --- CONFIGURACIÓN DE OSCURIDAD ---
// 0.0 = Transparente (Día)
// 1.0 = Negro Total
// 0.85 = Oscuridad navegable
darkness_alpha = 0.85;