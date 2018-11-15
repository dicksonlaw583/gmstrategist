 /// @description Mop up state and tree
if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
  script_execute(ruleset[RULESET.SCR_CLEANUP], state);
}
tree[MCTS_TREE.ROOT] = undefined;
tree = undefined;
