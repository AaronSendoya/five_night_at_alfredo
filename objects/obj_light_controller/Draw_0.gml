/// @description DIBUJAR SISTEMA DE LUZ (Surface)

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
var _ancho = 1.8; // Antes 1 (Más ancho = más visión periférica)
var _largo = 1.6; // Antes 1 (Más largo = llega más lejos)

// 1. SI LA SUPERFICIE NO EXISTE, LA CREAMOS
if (!surface_exists(light_surface)) {
    light_surface = surface_create(_cam_w, _cam_h);
}

// 2. EMPEZAMOS A DIBUJAR EN LA SUPERFICIE (No en la pantalla)
surface_set_target(light_surface);

// A. Limpiamos todo con color NEGRO (Oscuridad base)
draw_clear_alpha(c_black, 0); // Limpiar basura anterior
draw_set_color(c_black);

// Lógica de "Apagón Global"
var _final_darkness = darkness_alpha; 
if (global.power_on) _final_darkness = 0.3; // Si hay luz, la oscuridad es suave (0.3)
if (global.power_on && global.lights_flickering && choose(true, false)) _final_darkness = 0.6; // Parpadeo

draw_set_alpha(_final_darkness);
draw_rectangle(0, 0, _cam_w, _cam_h, false); // Pintamos toda la oscuridad

// 3. RECORTAR LA LINTERNA (Aquí ocurre la magia)
// Usamos bm_subtract para "borrar" la oscuridad donde esté la luz
gpu_set_blendmode(bm_subtract);

if (instance_exists(obj_linterna)) {
    with (obj_linterna) {
        if (has_flashlight && is_on && light_alpha > 0) {
            
            // Calculamos la posición relativa a la cámara (porque la surface se mueve con ella)
            var _draw_x = x - _cam_x;
            var _draw_y = y - _cam_y;
            
            // Dibujamos el cono de luz. Lo que sea blanco en el sprite, se volverá TRANSPARENTE en la oscuridad.
            draw_sprite_ext(spr_light_beam, 0, _draw_x, _draw_y, _ancho, _largo, beam_angle, c_white, light_alpha);
            
            // Un pequeño círculo en el origen para que el jugador se vea un poco
            draw_circle(_draw_x, _draw_y, 25, false);
        }
    }
}

// 4. RESTAURAR Y DIBUJAR EN PANTALLA
gpu_set_blendmode(bm_normal); // Volver a modo normal
draw_set_alpha(1);
surface_reset_target(); // Dejar de dibujar en la surface

// Finalmente, dibujamos la superficie sobre el juego
draw_surface(light_surface, _cam_x, _cam_y);