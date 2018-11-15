/// @description Handle mh_ai_thinks
if (async_load[? "id"] == mh_ai_thinks) {
  mh_ai_thinks = -1;
  // Go back to apply the move
  event_user(1);
}


///Handle mh_new_game
if (async_load[? "id"] == mh_new_game) {
  mh_new_game = -1;
  // Ask for a move
  event_user(0);
}


///Handle mh_hint
if (async_load[? "id"] == mh_hint) {
  mh_hint = -1;
  // Go back to asking for a move
  event_user(0);
}


///Handle mh_illegal
if (async_load[? "id"] == mh_illegal) {
  mh_illegal = -1;
  // Go back to asking for a move
  event_user(0);
}


///Handle mh_winner
if (async_load[? "id"] == mh_winner) {
  mh_winner = -1;
  // Play again?
  qh_replay = show_question_async("Play again?");
}


///Handle ih_input
if (async_load[? "id"] == ih_input) {
  ih_input = -1;
  // Not cancelled
  if (async_load[? "status"]) {
    input = async_load[? "result"];
    // Special commands
    switch (string_lower(input)) {
      // Create a new tree and come up with a hint
      case ":hint":
        // Only one move, make that clear
        var available_moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], state);
        if (array_length_1d(available_moves) == 1) {
          recommendation = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], available_moves[0]);
          mh_hint = show_message_async("You have only one move: " + recommendation);
        }
        // Multiple moves, create a tree
        else {
          hint_tree = MctsTree(state, ruleset, configs);
          hint_evaluation_daemon = mcts_evaluate_in_background(hint_tree, max_playout_plies, max_eval_playouts, max_playout_ms, max_eval_ms);
        }
        exit;
      // Restart with the same opening game state
      case ":restart":
        event_user(15); // Cleanup
        state = script_execute(ruleset[RULESET.SCR_DECODE], state_pickle);
        tree = MctsTree(state, ruleset, configs);
        mh_new_game = show_message_async("Game restarted:" + chr(10) + chr(10) + script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + chr(10) + chr(10) + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state)) + " plays first.");
        exit;
      // Start a new game with a new game state
      case ":newgame":
        event_user(15); // Cleanup
        event_user(14); // Start new game
        exit;
      // Finish playing without ending game
      case ":finish":
        event_user(15); // Cleanup
        instance_destroy();
        exit;
      // Finish playing and end game
      case ":quit":
        event_user(15); // Cleanup
        instance_destroy();
        game_end();
        exit;
    }
    // Attempt to convert the move from the input
    move = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_INPUT], input);
    // If not a valid move, ask again
    if (is_undefined(move)) {
      event_user(0);
      exit;
    }
    // If valid move, break off if the move is illegal
    if (!is_undefined(move) && !script_execute(ruleset[RULESET.SCR_IS_LEGAL], state, move)) {
      mh_illegal = show_message_async("That move is illegal.");
      exit;
    }
    // Apply the move to the state
    event_user(1);
  }
  // Cancelled, retry
  else {
    event_user(0);
  }
}


///Handle qh_replay
if (async_load[? "id"] == qh_replay) {
  qh_replay = -1;
  if (async_load[? "status"]) {
    event_user(14);
  } else {
    instance_destroy();
  }
}


