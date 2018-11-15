/// @description MctsNode(last_move, last_player, weight, reward, visits, children[])
/// @param last_move
/// @param  last_player
/// @param  weight
/// @param  reward
/// @param  visits
/// @param  children[]
/**
Build a new MCTS node.

MctsNode[
  Move LAST_MOVE, // The last move made (can be undefined if root)
  Player|undefined LAST_PLAYER, // The last player to play (can be undefined if root or chance)
  Int WEIGHT, // Weight
  Int REWARD, // Cumulative reward
  Int VISITS, // Number of visits
  MctsNode[] CHILDREN, // Children nodes
]
*/
enum MCTS_NODE {
  LAST_MOVE,
  LAST_PLAYER,
  WEIGHT,
  REWARD,
  VISITS,
  CHILDREN,
}
{
	return [
		argument0,
		argument1,
		argument2,
		argument3,
		argument4,
		argument5
	];
}
