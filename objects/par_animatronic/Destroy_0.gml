/// @description Cleanup par_animatronic
if (ds_exists(recent_patrol_points, ds_type_list)) {
    ds_list_destroy(recent_patrol_points);
}
