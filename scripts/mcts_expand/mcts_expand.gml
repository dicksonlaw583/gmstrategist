/// @description mcts_expand(@node, state, ruleset)
/// @param @node
/// @param  state
/// @param  ruleset
/**
Default expansion policy.
Expand all possible moves from the given node state, then return the first expanded node.
*/
{
  // Capture parameters
  var node = argument0,
      node_state = argument1,
      ruleset = argument2,
      node_children = node[MCTS_NODE.CHILDREN];
  // Compute information about the given state
  var moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], node_state),
      moves_available = array_length_1d(moves),
      last_player = script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], node_state);
  // If there are no more moves, return undefined right away
  if (moves_available == 0) {
    return undefined;
  }
  // For each available move
  for (var i = moves_available-1; i >= 0; i--) {
    var move = moves[i];
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
  // Return the first child node
  return node_children[0]
}
