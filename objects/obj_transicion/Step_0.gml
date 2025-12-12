/// @description Lógica del Fade en Mapa Gigante

if (estado == "saliendo") {
    // 1. Oscurecer la pantalla
    alpha += velocidad_efecto;
    
    // 2. Cuando sea totalmente negro... ¡TELETRANSPORTAMOS!
    if (alpha >= 1) {
        
        // --- EL CAMBIO ESTÁ AQUÍ (Ya no hay room_goto) ---
        
        // A. Mover al jugador a la nueva coordenada
        obj_jugador.x = target_x;
        obj_jugador.y = target_y;
        
        // B. Cambiar sprite (si hace falta)
        if (target_sprite != -1) {
            obj_jugador.sprite_index = target_sprite;
        }
        
        // C. MOVER LA CÁMARA DE GOLPE (SNAP)
        // Esto es vital. Mientras está negro, forzamos a la cámara a ir
        // a la nueva posición para que no se vea un "barrido" raro.
        var _cam_w = camera_get_view_width(view_camera[0]);
        var _cam_h = camera_get_view_height(view_camera[0]);
        
        // Centramos la cámara en el nuevo punto del jugador
        camera_set_view_pos(view_camera[0], target_x - _cam_w/2, target_y - _cam_h/2);
        
        // --------------------------------------------------
        
        // Empezar a aclarar
        estado = "entrando";
    }
} 
else if (estado == "entrando") {
    // 3. Aclarar la pantalla
    alpha -= velocidad_efecto;

    // 4. Si ya terminó de aclararse...
    if (alpha <= 0) {

        // AQUÍ ESTÁ EL TRUCO:
        // No activamos "puede_moverse = true" directamente.
        // En su lugar, encendemos la mecha de la alarma.

        obj_jugador.alarm[0] = 30; // 60 frames = 1 Segundo de espera

        instance_destroy(); // Borramos la transición
    }
}