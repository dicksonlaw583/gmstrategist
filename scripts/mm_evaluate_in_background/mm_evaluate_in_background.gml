/// @description mm_evaluate_in_background(@MmTree tree, Int max_depth)
/// @param @MmTree tree
/// @param  Int max_depth
/**
Fully expand the unbuilt minimax tree to the given maximum depth in the background using a daemon.
Return the instance ID of the created daemon. It has a progress variable in [0, 1] and a Boolean done variable.
*/
{
  var inst = instance_create_depth(0, 0, 0, __obj_minimax_daemon__);
  with (inst) {
    tree = argument0;
    max_depth = argument1;
    event_user(0);
  }
  return inst;
}
