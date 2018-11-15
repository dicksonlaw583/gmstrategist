/// @description RawMctsTree(root, root_pickle, ruleset, mcts_configs)
/// @param root
/// @param  root_pickle
/// @param  ruleset
/// @param  mcts_configs
/**
This is the low-level constructor for MctsTree. Use MctsTree() for non-testing situations.

MctsTree[
  MctsNode ROOT, // Root node
  SerializedState ROOT_PICKLE, // Serialized version of root state
  Ruleset RULESET, // Ruleset
  MctsConfigs CONFIGS, // MCTS configurations
]
*/
enum MCTS_TREE {
  ROOT,
  ROOT_PICKLE,
  RULESET,
  CONFIGS
}
{
	return [
		argument0,
		argument1,
		argument2,
		argument3
	];
}
