/// @description Debug de IA (solo si debug_mode)

draw_self();

if (global.debug_mode) {

    draw_set_color(c_white);

    var _state_name = "NO_STATE";
    if (is_undefined(get_state_name)) {
        _state_name = "NO_FN";
    } else {
        _state_name = get_state_name();
    }

    draw_text(x, y - 32, _state_name + " | AI:" + string(ai_level));

    draw_set_alpha(0.15);

    draw_set_color(c_lime);
    draw_circle(x, y, vision_range, false);

    draw_set_color(c_aqua);
    draw_circle(x, y, hearing_range_base, false);

    var _segments = 24;
    var _start = facing_angle - vision_half_angle;
    var _end   = facing_angle + vision_half_angle;
    var _step  = (_end - _start) / _segments;

    draw_set_color(c_lime);
    draw_set_alpha(0.25);

    draw_primitive_begin(pr_trianglefan);
    draw_vertex(x, y);

    for (var i = 0; i <= _segments; i++) {
        var _ang = _start + _step * i;
        var _vx  = x + lengthdir_x(vision_range, _ang);
        var _vy  = y + lengthdir_y(vision_range, _ang);
        draw_vertex(_vx, _vy);
    }

    draw_primitive_end();

    draw_set_alpha(1);
}
