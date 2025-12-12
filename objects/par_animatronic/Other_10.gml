/// @description Reacción ODM base (sobrescribir en hijos)

// Aquí no hace nada en el padre.
// Los hijos implementan su lógica específica, por ejemplo:
//
// - Elegir nuevo target de patrulla
// - Pasar de IDLE a PATROL
// - Intentar pasar a CHASE:
//
// if (director_request_chase()) {
//     state = AI_STATE_CHASE;
// }
//
// Si termina persecución en algún momento, el hijo llama:
// director_end_chase();
