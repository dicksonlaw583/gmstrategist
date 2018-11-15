/// @description mcts_reweight(@node, parent, reward, ?)
/// @param @node
/// @param  parent
/// @param  reward
/// @param  ?
/**
Reweight the given node by adding the given reward, using the default learning UCT parameter sqrt(2).
*/
{
  // Capture parameters
  var node = argument0,
      parent = argument1,
      reward = argument2,
      _ = argument3;
  // Accumulate the reward
  node[@MCTS_NODE.REWARD] += reward;
  // Overwrite the node's weight with UCT
  node[@MCTS_NODE.WEIGHT] = node[MCTS_NODE.REWARD]/node[MCTS_NODE.VISITS] + sqrt(2*ln(parent[MCTS_NODE.VISITS]+1)/node[MCTS_NODE.VISITS]);
}
