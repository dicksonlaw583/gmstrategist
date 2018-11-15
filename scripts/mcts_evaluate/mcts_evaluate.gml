/// @description mcts_evaluate(@tree, max_playout_plies, max_playout_ms, max_eval_playouts, max_eval_ms)
/// @param @tree
/// @param  max_playout_plies
/// @param  max_playout_ms
/// @param  max_eval_playouts
/// @param  max_eval_ms
/**
Evaluate the given tree using the given limit on plies per playout, time per playout, total # of playouts and total time.
*/
{
  var tree = argument0,
      max_playout_plies = argument1,
      max_playout_ms = argument2,
      max_total_playouts = argument3,
      max_total_ms = argument4,
      tree_root = tree[MCTS_TREE.ROOT],
      tree_ruleset = tree[MCTS_TREE.RULESET],
      tree_configs = tree[MCTS_TREE.CONFIGS];
  var start_time = current_time,
      playouts = 0;
  do {
    // Select (1): Use the provided seletion strategy to dig down the tree for a node to expand
    var path = script_execute(tree_configs[MCTS_CONFIG.SCR_SELECT], tree_root, tree_configs[MCTS_CONFIG.ARG_SELECT]);
    var path_size = array_length_1d(path);
    var play_state = script_execute(tree_ruleset[RULESET.SCR_DECODE], tree[MCTS_TREE.ROOT_PICKLE]);
    // Apply the moves visited by the path on the experimental state (except for root)
    for (var i = 1; i < path_size; i++) {
      var node = path[i];
      script_execute(tree_ruleset[RULESET.SCR_APPLY_MOVE], play_state, node[MCTS_NODE.LAST_MOVE]);
    }
    // Expand (2): Use the provided expansion strategy to return a node to expand
    // Exception: If the node to expand is a final node, use final playout strategy to determine its result
    var playout_result;
    if (script_execute(tree_ruleset[RULESET.SCR_IS_FINAL], play_state)) {
      playout_result = script_execute(tree_ruleset[RULESET.SCR_PLAYOUT_RESULT], play_state);
    }
    // Playout (3): Determine a result from the expanded node's state.
    // If not found, use the playout strategy on the experimental state to determine its result
    else {
      var play_node = script_execute(tree_configs[MCTS_CONFIG.SCR_EXPAND], path[path_size-1], play_state, tree_configs[MCTS_CONFIG.ARG_EXPAND]);
      path[@path_size++] = play_node;
      script_execute(tree_ruleset[RULESET.SCR_APPLY_MOVE], play_state, play_node[MCTS_NODE.LAST_MOVE]);
      playout_result = script_execute(tree_configs[MCTS_CONFIG.SCR_PLAYOUT], play_state, max_playout_plies, max_playout_ms, tree_configs[MCTS_CONFIG.ARG_PLAYOUT]);
    }
    // Back-propagation (4): For each node along the path from the expanded node to the root, increment its visit count and the reward given by the playout interpreter
    // IMPORTANT: The reward is from the perspective of the player leading to the current node, not the player about to make a move!
    var parent_node = path[0];
    parent_node[@MCTS_NODE.VISITS]++;
    for (var i = 1; i < path_size; i++) {
      var node = path[i];
      node[@MCTS_NODE.VISITS]++;
      script_execute(tree_configs[MCTS_CONFIG.SCR_REWEIGHT], node, parent_node, script_execute(tree_configs[MCTS_CONFIG.SCR_INTERPRET], play_state, playout_result, node[MCTS_NODE.LAST_PLAYER], tree_configs[MCTS_CONFIG.ARG_INTERPRET]), tree_configs[MCTS_CONFIG.ARG_REWEIGHT]);
      parent_node = node;
    }
    // Cleanup: Call the cleanup strategy of the tree to free resources allocated to the experimental play state.
    if (!is_undefined(tree_ruleset[RULESET.SCR_CLEANUP])) {
      script_execute(tree_ruleset[RULESET.SCR_CLEANUP], play_state);
    }
    // This is necessary only if the live state uses dynamically allocated resources that need manual freeing, e.g. ds_* data structures
  } until ((current_time-start_time >= max_total_ms) || (playouts++ > max_total_playouts));
  return playouts;
}
