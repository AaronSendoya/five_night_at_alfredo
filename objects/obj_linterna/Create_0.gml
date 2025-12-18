/// @description Configuración Final

// --- PROFUNDIDAD CRÍTICA ---
// Debe ser menor que el light_controller (que suele ser 0 o -100)
// Esto asegura que la luz se dibuje ENCIMA del rectángulo negro.
depth = -15000; 

// --- ESTADO INICIAL ---
has_flashlight = false; // Empieza sin ella (debes recogerla con el pickup)
is_on = false;
is_cranking = false;

// --- BATERÍA (45 Segundos aprox) ---
battery_max = 2700; 
battery_level = battery_max;
drain_rate = 1;      
charge_rate = 15;    

// --- VISUALES ---
light_alpha = 0;     
flicker_timer = 0;   
beam_angle = 0; // Ángulo hacia donde apunta la luz

// --- CONTROLES ---
key_toggle = ord("F");
key_crank  = vk_space;

// ... (Tu código anterior) ...

// --- MENSAJE DE RECARGA (UX) ---
msg_timer = 0;          // Tiempo que dura el mensaje en pantalla
msg_duration = 180;     // 3 Segundos (60 frames * 3)
battery_was_empty = false; // Para detectar el momento exacto en que se acaba