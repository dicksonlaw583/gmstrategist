/// @description mcts_get_ranked_moves(tree)
/// @param tree
/**
Return an array of immediate next moves in descending order of visits, as indicated by the given tree.
*/
{
  // Capture parameters
  var root = argument0[MCTS_TREE.ROOT],
      children = root[MCTS_NODE.CHILDREN];
  // Create priority queue of moves
  var pq = ds_priority_create();
  // For each child of the root
  for (var i = array_length_1d(children)-1; i >= 0; i--) {
    // Insert its move number into the queue with visits as the priority
    var current_child = children[i];
    ds_priority_add(pq, i, current_child[MCTS_NODE.VISITS]);
  }
  // Get the best child
  var best_move = children[ds_priority_find_max(pq)];
  // Clean up the priority queue
  ds_priority_destroy(pq);
  // Return the move of the best child
  return best_move;
}
