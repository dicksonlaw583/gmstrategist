/// @description mcts_get_best_move_sequence(tree)
/// @param tree
/**
Return the sequence of best moves for each player in sequence, as indicated by the given tree.
*/
{
  // Capture parameters
  var current_node = argument0[MCTS_TREE.ROOT],
      current_node_children = current_node[MCTS_NODE.CHILDREN],
      current_node_children_count = array_length_1d(current_node_children);
  // Set up move sequence to return
  var move_sequence = array_create(0),
      move_sequence_length = 0;
  // As long as the current_node has children
  while (current_node_children_count > 0) {
    // Tentatively, first child is best
    var best_child = current_node_children[0],
        best_visits = best_child[MCTS_NODE.VISITS];
    // For each subsequent child of the root
    for (var i = current_node_children_count-1; i >= 1; i--) {
      var current_child = current_node_children[i],
          current_child_visits = current_child[MCTS_NODE.VISITS];
      // Displace the best child if it has more visits
      if (current_child_visits > best_visits) {
        best_child = current_child;
        best_visits = current_child_visits;
      }
    }
    // Extend the path by the best child's move
    move_sequence[@move_sequence_length++] = best_child[MCTS_NODE.LAST_MOVE];
    // Change current node to best child
    current_node = best_child;
    current_node_children = current_node[MCTS_NODE.CHILDREN];
    current_node_children_count = array_length_1d(current_node_children);
  }
  // Return move sequence
  return move_sequence;
}
