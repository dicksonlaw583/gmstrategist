/// @description MctsTree(state, ruleset, mcts_configs)
/// @param state
/// @param  ruleset
/// @param  mcts_configs
/**
Build an MCTS tree from the given state, ruleset and MCTS configs.
See RawMctsTree() for implementation details.
*/
{
  var a = argument0,
      b = argument1,
      c = argument2;
  return RawMctsTree(
    MctsNode(
      undefined,
      undefined,
      0,
      0,
      0,
      array_create(0)
    ),
    script_execute(argument1[RULESET.SCR_ENCODE], argument0),
    argument1,
    argument2
  );
}
