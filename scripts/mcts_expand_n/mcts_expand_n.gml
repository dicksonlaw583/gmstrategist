/// @description mcts_expand_n(@node, state, [ruleset;n])
/// @param @node
/// @param  state
/// @param  [ruleset;n]
/**
Expand up to n random possible moves from the given node state, then return the first expanded node.
*/
{
  // Capture parameters
  var node = argument0,
      node_state = argument1,
      ruleset = argument2[0],
      n = argument2[1],
      node_children = node[MCTS_NODE.CHILDREN];
  // Compute information about the given state
  var moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], node_state),
      moves_available = array_length_1d(moves),
      last_player = script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], node_state);
  // If there are no more moves, return undefined right away
  if (moves_available == 0) {
    return undefined;
  }
  // Create shuffling list
  var shuffle = ds_list_create();
  // For each available move
  for (var i = moves_available-1; i >= 0; i--) {
    // Add its index into the shuffling list
    ds_list_add(shuffle, i);
  }
  // Shuffle the list
  ds_list_shuffle(shuffle);
  // Pop up to n moves as children
  if (n > moves_available) {
    n = moves_available;
  }
  for (var i = 0; i < n; i++) {
    var move = moves[shuffle[|0]];
    ds_list_delete(shuffle, 0);
    // Add a child into the node's list of children
    node_children[@i] = MctsNode(
      move,
      last_player,
      undefined, // << This is important: It marks an unexplored node!
      0,
      0,
      array_create(0)
    );
  }
  // Clean shuffling list
  ds_list_destroy(shuffle);
  // Return the first child node
  return node_children[0]
}
