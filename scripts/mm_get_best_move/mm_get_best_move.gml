/// @description mm_get_best_move(tree)
/// @param tree
/**
Return the best immediate next move, as indicated by the given tree.
*/
{
  // Capture parameters
  var tree = argument0,
      root = tree[MM_TREE.ROOT],
      root_children = root[MM_NODE.CHILDREN],
      root_children_count = array_length_1d(root_children);
  // No children = no move
  if (root_children_count == 0) return undefined;
  // Default best is first
  var current_node = root_children[0],
      current_value = current_node[MM_NODE.VALUE],
      best_move = current_node[MM_NODE.LAST_MOVE],
      best_value = current_value;
  // For each child node of root
  for (var i = root_children_count-1; i >= 1; i--) {
    current_node = root_children[i];
    current_value = current_node[MM_NODE.VALUE];
    if ((root[MM_NODE.POLARITY] > 0) == (current_node[MM_NODE.VALUE] > best_value)) {
      best_move = current_node[MM_NODE.LAST_MOVE];
      best_value = current_value;
    }
  }
  // Return best move
  return best_move;
}
