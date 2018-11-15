/// @description MmNode(last_move, polarity, value, children)
/// @param last_move
/// @param  polarity
/// @param  value
/// @param  children
/**
Build a new Minimax node.

MmNode[
  Move|undefined LAST_MOVE, // The last move made before this state (can be undefined if root)
  -1|1 POLARITY, //-1 = min node, 1 = max node
  Real VALUE, // Value of the node
  MmNode[] CHILDREN // Children nodes
]
*/
enum MM_NODE {
  LAST_MOVE,
  POLARITY,
  VALUE,
  CHILDREN
}
{
  return [
		argument0,
		argument1,
		argument2,
		argument3
	];
}
