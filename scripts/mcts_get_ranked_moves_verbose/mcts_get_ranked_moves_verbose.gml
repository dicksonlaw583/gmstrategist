/// @description mcts_get_ranked_moves_verbose(tree)
/// @param tree
/**
Return a 2D array of immediate next moves in descending order of visits, as indicated by the given tree.
result[n, 0] = Move
result[n, 1] = # of visits
result[n, 2] = Equity (cumulative reward / visits)
result[n, 3] = Weight
*/
{
  // Capture parameters
  var root = argument0[MCTS_TREE.ROOT],
      children = root[MCTS_NODE.CHILDREN],
      children_count = array_length_1d(children);
  // Create priority queue of moves
  var pq = ds_priority_create();
  // For each child of the root
  for (var i = children_count-1; i >= 0; i--) {
    // Insert its move number into the queue with visits as the priority
    var current_child = children[i];
    ds_priority_add(pq, i, current_child[MCTS_NODE.VISITS]);
  }
  // For each move number in the priority queue (build ranked_result backwards)
  var ranked_result;
  for (var j = children_count-1; j >= 0; j--) {
    var current_child = children[ds_priority_delete_min(pq)];
    ranked_result[j, 3] = current_child[MCTS_NODE.WEIGHT];
    ranked_result[j, 2] = current_child[MCTS_NODE.REWARD]/current_child[MCTS_NODE.VISITS];
    ranked_result[j, 1] = current_child[MCTS_NODE.VISITS];
    ranked_result[j, 0] = current_child[MCTS_NODE.LAST_MOVE];
  }
  // Clean up the priority queue
  ds_priority_destroy(pq);
  // Return the ranked result
  return ranked_result;
}
