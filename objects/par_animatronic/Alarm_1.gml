/// @description Dejar de buscar (HUNT timeout)
if (state == STATE.HUNT) {
    state = STATE.IDLE;
    alarm[0] = room_speed * 1;
}