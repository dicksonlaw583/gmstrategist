/// @description mcts_get_best_move(tree)
/// @param tree
/**
Return the best immediate next move, as indicated by the given tree.
*/
{
  // Capture parameters
  var root = argument0[MCTS_TREE.ROOT],
      children = root[MCTS_NODE.CHILDREN];
  // Tentatively, first child is best
  var best_child = children[0],
      best_visits = best_child[MCTS_NODE.VISITS];
  // For each subsequent child of the root
  for (var i = array_length_1d(children)-1; i >= 1; i--) {
    var current_child = children[i],
        current_child_visits = current_child[MCTS_NODE.VISITS];
    // Displace the best child if it has more visits
    if (current_child_visits > best_visits) {
      best_child = current_child;
      best_visits = current_child_visits;
    }
  }
  // Return the move of the best child
  return best_child[MCTS_NODE.LAST_MOVE];
}
