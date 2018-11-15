/// @description Accept move
{
// Apply the move to the state
script_execute(ruleset[RULESET.SCR_APPLY_MOVE], state, move);
// Reset the tree
tree[MCTS_TREE.ROOT] = undefined;
tree = undefined;
tree = MmTree(state, ruleset, configs);
// Reset recommendations
recommendation = "";
// Ask for the next move
event_user(0);
}


