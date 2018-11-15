/// @description MmTree(state, ruleset, mm_configs)
/// @param state
/// @param  ruleset
/// @param  mm_configs
/**
Build a minimax tree from the given state, ruleset and configs.
See RawMmTree() for implementation details.
*/
{
  return RawMmTree(
    MmNode(
      undefined,
      script_execute(argument2[MM_CONFIGS.SCR_POLARITY], script_execute(argument1[RULESET.SCR_CURRENT_PLAYER], argument0)),
      undefined,
      array_create(0)
    ),
    script_execute(argument1[RULESET.SCR_ENCODE], argument0),
    argument1,
    argument2
  );
}
