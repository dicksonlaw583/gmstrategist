/// @description mm_get_ranked_moves_verbose(tree)
/// @param tree
/**
Return a 2D array of immediate next moves in descending order of value, as indicated by the given tree.
result[n, 0] = Move
result[n, 1] = Value
*/
{
  // Capture parameters
  var tree = argument0,
      root = tree[MM_TREE.ROOT],
      root_children = root[MM_NODE.CHILDREN],
      root_children_count = array_length_1d(root_children);
  // Set up data
  var pq = ds_priority_create(),
      result = undefined;
  // Push in moves iteratively with weight
  for (var i = root_children_count-1; i >= 0; i--) {
    var current_child = root_children[i];
    ds_priority_add(pq, current_child, current_child[MM_NODE.VALUE]);
  }
  // Pop out moves biggest first
  for (var i = 0; i < root_children_count; i++) {
    var current_child;
    if (root[MM_NODE.POLARITY] > 0) {
      current_child = ds_priority_delete_max(pq);
    } else {
      current_child = ds_priority_delete_min(pq);
    }
    result[i, 1] = current_child[MM_NODE.VALUE];
    result[i, 0] = current_child[MM_NODE.LAST_MOVE];
  }
  // Clean PQ
  ds_priority_destroy(pq);
  // Return result
  return result;
}
