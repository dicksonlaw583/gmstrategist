/// @description mcts_reroot(@tree, moves[])
/// @param @tree
/// @param  moves[]
/**
Change the tree's root to the state after making the given moves in sequence.
*/
{
  // Capture parameters
  var tree = argument0,
      reroot_moves = argument1,
      reroot_moves_count = array_length_1d(reroot_moves),
      ruleset = tree[MCTS_TREE.RULESET];
  // Get temporary state for the current root
  var state = script_execute(ruleset[RULESET.SCR_DECODE], tree[MCTS_TREE.ROOT_PICKLE]),
      new_root = tree[MCTS_TREE.ROOT];
  // For each move to apply
  for (var i = 0; i < reroot_moves_count; i++) {
    var move = reroot_moves[i];
    // If the candidate new root has been expanded
    if (!is_undefined(new_root)) {
      // Without further evidence, new root is in uncharted territory
      var candidate_new_root = undefined,
          new_root_children = new_root[MCTS_NODE.CHILDREN];
      // For each children of the current node
      for (var j = array_length_1d(new_root_children)-1; j >= 0; j--) {
        var new_root_child = new_root_children[j],
            new_root_child_move = new_root_child[MCTS_NODE.LAST_MOVE];
        // If the move matches the current move, mark it as the candidate new root
        // This would mean the next move is still in charted territory
        if (is_undefined(candidate_new_root)) {
          if ((typeof(move) == typeof(new_root_child)) &&
              ((!is_array(move) && move == new_root_child_move) || (is_array(move) && array_equals(new_root_child_move, move)))) {
            candidate_new_root = new_root_child;
          }
        }
        // Blank out that child entry's reference to GC
        new_root_children[@j] = undefined;
      }
      // Update the candidate new root
      new_root = candidate_new_root;
    }
    // Apply the move to the temporary state
    script_execute(ruleset[RULESET.SCR_APPLY_MOVE], state, move);
  }
  // If the new root isn't already computed, create it
  if (is_undefined(new_root)) {
    new_root = MctsNode(
      undefined,
      undefined,
      0,
      0,
      0,
      array_create(0)
    );
  }
  // Update the root pickle
  tree[@MCTS_TREE.ROOT_PICKLE] = undefined;
  tree[@MCTS_TREE.ROOT_PICKLE] = script_execute(ruleset[RULESET.SCR_ENCODE], state);
  // Clean up the state if applicable
  if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
    script_execute(ruleset[RULESET.SCR_CLEANUP], state);
  }
  // Forget the current root and set the new root
  tree[@MCTS_TREE.ROOT] = undefined;
  tree[@MCTS_TREE.ROOT] = new_root;
}
