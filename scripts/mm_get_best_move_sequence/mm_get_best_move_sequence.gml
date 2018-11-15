/// @description mm_get_best_move_sequence(tree)
/// @param tree
/**
Return the sequence of best moves for each player in sequence, as indicated by the given tree.
*/
{
  // Capture parameters
  var tree = argument0,
      root = tree[MM_TREE.ROOT],
      root_children = root[MM_NODE.CHILDREN],
      root_children_count = array_length_1d(root_children);
  // Temporary sequence
  var best_move_sequence = array_create(0);
  // No children = no move
  if (root_children_count == 0) return best_move_sequence;
  // As long as I can dig...
  while (root_children_count > 0) {
    // Default best is first
    var current_node = root_children[0],
        current_value = current_node[MM_NODE.VALUE],
        best_move = current_node[MM_NODE.LAST_MOVE],
        best_move_num = 0,
        best_value = current_value;
    // For each child node of root
    for (var i = root_children_count-1; i >= 1; i--) {
      current_node = root_children[i];
      current_value = current_node[MM_NODE.VALUE];
      if ((root[MM_NODE.POLARITY] > 0) == (current_value > best_value)) {
        best_move = current_node[MM_NODE.LAST_MOVE];
        best_move_num = i;
        best_value = current_value;
      }
    }
    // Append best move to path
    best_move_sequence[array_length_1d(best_move_sequence)] = best_move;
    // Dig down to best move's node
    root = root_children[best_move_num];
    root_children = root[MM_NODE.CHILDREN];
    root_children_count = array_length_1d(root_children);
  }
  // Return best move sequence
  return best_move_sequence;
}
