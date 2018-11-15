/// @description Expand the tree
{
if (is_array(tree) && elapsed_ms <= max_ms && elapsed_playouts <= max_playouts && !ready) {
  var ref_fps = fps_real;
  if (os_browser != browser_not_a_browser) {
    ref_fps = fps;
  }
  if (ref_fps < room_speed*congestion_factor) {
    step_time_limit *= 1-congestion_cut;
  } else {
    step_time_limit += slow_start_increment;
  }
  var time_slice = min(max_ms-elapsed_ms, max(min_slice, max_playout_ms, step_time_limit)),
      start_time = current_time,
      evaluations = mcts_evaluate(tree, max_playout_plies, time_slice, max_playouts-elapsed_playouts, time_slice);
  elapsed_playouts += evaluations;
  elapsed_ms += current_time-start_time;
  progress = max(elapsed_ms/max_ms, elapsed_playouts/max_playouts);
  if (elapsed_ms > max_ms || elapsed_playouts > max_playouts) {
    ready = true;
    progress = 1;
    if (!is_undefined(callback) && !script_execute(callback, mcts_get_best_move(tree), callback_arg)) {
      instance_destroy();
    }
  }
}
}


