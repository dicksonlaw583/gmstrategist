/// @description RawMmTree(root, root_pickle, ruleset, mm_configs)
/// @param root
/// @param  root_pickle
/// @param  ruleset
/// @param  mm_configs
/**
Build a raw minimax tree.

MmTree[
  MmNode ROOT, // Root node
  SerializedState ROOT_PICKLE, // Serialized root state
  Ruleset RULESET, // Ruleset
  MmConfigs CONFIGS, // Minimax configurations
]
*/
enum MM_TREE {
  ROOT, //MmNode
  ROOT_PICKLE, //SerializedState
  RULESET, //Ruleset
  CONFIGS //MmConfigs
}
{
  return [
		argument0,
		argument1,
		argument2,
		argument3
	];
}
