/// @description Accept move
// Apply the move to the state
script_execute(ruleset[RULESET.SCR_APPLY_MOVE], state, move);
// Re-root the tree
var _move = array_create(1);
_move[0] = move;
mcts_reroot(tree, _move);
// Reset recommendations
recommendation = "";
// Ask for the next move
event_user(0);
