/// @description Expand the tree
{
if (is_array(tree) && !ready) {
  var ref_fps = fps_real;
  if (os_browser != browser_not_a_browser) {
    ref_fps = fps;
  }
  if (ref_fps < room_speed*congestion_factor) {
    step_time_limit *= 1-congestion_cut;
  } else {
    step_time_limit += slow_start_increment;
  }
  var time_slice = max(min_slice, step_time_limit);
  if (progress < 1) {
    progress = mm_evaluate_partial(tree, max_depth, time_slice, stack);
  }
  if (progress == 1) {
    ready = true;
    if (!is_undefined(callback) && !script_execute(callback, mm_get_best_move(tree), callback_arg)) {
      instance_destroy();
    }
  }
}
}


