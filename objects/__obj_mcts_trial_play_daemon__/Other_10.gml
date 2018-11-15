/// @description Ask for moves unless the game is finished
// Not over, ask for a move
if (!script_execute(ruleset[RULESET.SCR_IS_FINAL], state)) {
  // Determine the current player's agency and find a move
  current_player = script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state);
  current_agency = script_execute(text_gameset[TEXT_GAMESET.SCR_AGENCY], current_player);
  move = undefined;
  input = "";
  switch (current_agency) {
    // Tree
    
    case TEXT_GAMESET_AGENCY.MAIN_TREE:
      evaluation_daemon = mcts_evaluate_in_background(tree, max_playout_plies, max_eval_playouts, max_playout_ms, max_eval_ms);
    break;
    // Player input
    case TEXT_GAMESET_AGENCY.USER_INPUT:
      var available_moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], state);
      if (array_length_1d(available_moves) == 1) {
        recommendation = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], available_moves[0]);
      }
      ih_input = get_string_async(script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + chr(10) + chr(10) + "Move for " + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], current_player) + ":", recommendation);
    break;
    // Script
    default:
      move = script_execute(current_agency, state);
      event_user(1);
      break;
  }
}
// Game over, clean up and announce results
else {
  // Announce results
  mh_winner = show_message_async(script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + chr(10) + chr(10) + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYOUT_COMMENT], script_execute(ruleset[RULESET.SCR_PLAYOUT_RESULT], state)));
  // Clean up
  if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
    script_execute(ruleset[RULESET.SCR_CLEANUP], state);
  }
  tree[MCTS_TREE.ROOT] = undefined;
  tree = undefined;
}
 