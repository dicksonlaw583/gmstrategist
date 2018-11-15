/// @description mcts_evaluate_in_background(@tree, max_playout_plies, max_playouts, max_playout_ms, max_ms)
/// @param @tree
/// @param  max_playout_plies
/// @param  max_playouts
/// @param  max_playout_ms
/// @param  max_ms
/**
Evaluate the given tree in the background using the given limit on plies per playout, time per playout, total # of playouts and total time.
Return the daemon instance performing this process. It has a progress variable in [0, 1] and a Boolean done variable.
*/
{
  with (instance_create_depth(0, 0, 0, __obj_mcts_daemon__)) {
    tree = argument0;
    max_playout_plies = argument1;
    max_playouts = argument2;
    max_playout_ms = argument3;
    max_ms = argument4;
    callback = undefined;
    callback_arg = undefined;
    event_user(0);
    return id;
  }
}
