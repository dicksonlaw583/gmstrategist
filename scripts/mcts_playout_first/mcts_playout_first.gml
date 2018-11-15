/// @description mcts_playout_first(@state, plies, ms, ruleset)
/// @param @state
/// @param  plies
/// @param  ms
/// @param  ruleset
/**
Play out the given state for up to the given number of plies and milliseconds.
This always uses the first generated move from the state, until the game is over or the ply/time limit runs out.
*/
{
  // Capture parameters
  var state = argument0,
      available_plies = argument1,
      max_ms = argument2,
      ruleset = argument3;
  // For up to the given number of plies 
  var ct = current_time;
  while ((available_plies-- > 0) && (current_time-ct < max_ms) && !script_execute(ruleset[RULESET.SCR_IS_FINAL], state)) {
    // Enumerate moves at the current state
    var moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], state);
    // Apply the first move to the given state
    script_execute(ruleset[RULESET.SCR_APPLY_MOVE], state, moves[0]);
  }
  // Return the playout
  return script_execute(ruleset[RULESET.SCR_PLAYOUT_RESULT], state);
}
