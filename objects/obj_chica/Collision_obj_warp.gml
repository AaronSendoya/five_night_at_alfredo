/// @description Prioridad de Paso en Misión

// Si Chica está en su misión sagrada de romper la luz...
if (estado_actual == "VIAJE" || estado_actual == "TRABAJO") {
    // NO HACER NADA. 
    // Al no tener código aquí y poner 'exit' o simplemente un comentario,
    // evitamos llamar a event_inherited().
    // Chica simplemente "caminará sobre" el objeto warp siguiendo su path.
    exit;
}

// Si está patrullando normal, que respete las pausas del padre
event_inherited();