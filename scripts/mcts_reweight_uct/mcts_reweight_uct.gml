/// @description mcts_reweight_uct(@node, parent, reward, c)
/// @param @node
/// @param  parent
/// @param  reward
/// @param  c
/**
Reweight the given node by adding the given reward, using the custom learning UCT parameter c.
*/
{
  // Capture parameters
  var node = argument0,
      parent = argument1,
      reward = argument2,
      c = argument3;
  // Accumulate the reward
  node[@MCTS_NODE.REWARD] += reward;
  // Overwrite the node's weight with UCT
  node[@MCTS_NODE.WEIGHT] = node[MCTS_NODE.REWARD]/node[MCTS_NODE.VISITS] + c*sqrt(ln(parent[MCTS_NODE.VISITS]+1)/node[MCTS_NODE.VISITS]);
}
