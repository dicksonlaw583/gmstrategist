/// @description mm_get_ranked_moves(tree)
/// @param tree
/**
Return an array of immediate next moves in descending order of value, as indicated by the given tree.
*/
{
  // Capture parameters
  var tree = argument0,
      root = tree[MM_TREE.ROOT],
      root_children = root[MM_NODE.CHILDREN],
      root_children_count = array_length_1d(root_children);
  // Set up data
  var pq = ds_priority_create(),
      result = array_create(root_children_count);
  // Push in moves iteratively with weight
  for (var i = root_children_count-1; i >= 0; i--) {
    var current_child = root_children[i];
    ds_priority_add(pq, current_child[MM_NODE.LAST_MOVE], current_child[MM_NODE.VALUE]);
  }
  // Pop out moves biggest first
  for (var i = 0; i < root_children_count; i++) {
    if (root[MM_NODE.POLARITY] > 0) {
      result[i] = ds_priority_delete_max(pq);
    } else {
      result[i] = ds_priority_delete_min(pq);
    }
  }
  // Clean PQ
  ds_priority_destroy(pq);
  // Return result
  return result;
}
