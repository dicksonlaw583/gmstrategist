/// @description mm_evaluate_with_callback(@MmTree tree, Int max_depth, scr_callback, arg_callback)
/// @param @MmTree tree
/// @param  Int max_depth
/// @param  scr_callback
/// @param  arg_callback
/**
Fully expand the unbuilt minimax tree to the given maximum depth in the background using a daemon.
When expansion completes, the script scr_callback will be called, with the best move in the first argument and arg_callback as the second argument.
scr_callback can optionally return a true value to keep the daemon instance alive, otherwise it will be automatically destroyed.
Return the instance ID of the created daemon. It has a progress variable in [0, 1] and a Boolean done variable.
*/
{
  var inst = instance_create_depth(0, 0, 0, __obj_minimax_daemon__);
  with (inst) {
    tree = argument0;
    max_depth = argument1;
    callback = argument2;
    callback_arg = argument3;
    event_user(0);
  }
  return inst;
}
