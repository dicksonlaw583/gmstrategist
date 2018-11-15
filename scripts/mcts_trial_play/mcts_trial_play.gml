/// @description mcts_trial_play(ruleset, configs, text_gameset, max_playout_plies, max_playout_ms, max_eval_playouts, max_eval_ms, ai_output, ai_verbose)
/// @param ruleset
/// @param  configs
/// @param  text_gameset
/// @param  max_playout_plies
/// @param  max_playout_ms
/// @param  max_eval_playouts
/// @param  max_eval_ms
/// @param  ai_output
/// @param  ai_verbose
/**
Allow the user to play against the preconfigured MCTS tree in a closed blocking loop. For debug use.
The MCTS tree is subject to the given time and evaluation constraints.
ai_output and ai_verbose accept the same arguments as mcts_output_ranked_moves().
*/
{
  // Capture arguments
  var ruleset = argument0,
      configs = argument1,
      text_gameset = argument2,
      max_playout_plies = argument3,
      max_playout_ms = argument4,
      max_eval_playouts = argument5,
      max_eval_ms = argument6,
      ai_output = argument7,
      ai_verbose = argument8,
      _scr_new_game = text_gameset[TEXT_GAMESET.SCR_NEW_GAME],
      _scr_state_display = text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY];
  // Newlines
  var lf = chr(13)+chr(10),
      lflf = lf+lf;
  // Repeat until the player quits
  do {
    // Create a new game
    var state = script_execute(_scr_new_game),
        state_pickle = script_execute(ruleset[RULESET.SCR_ENCODE], state),
        current_player = script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state),
        tree = MctsTree(state, ruleset, configs),
        input = "";
    show_message("New game:" + lflf + script_execute(_scr_state_display, state) + lflf + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], current_player) + " plays first.");
    // Make moves until the game is finished
    while (!script_execute(ruleset[RULESET.SCR_IS_FINAL], state)) {
      // Determine the current player's agency and find a move
      current_player = script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state);
      var current_agency = script_execute(text_gameset[TEXT_GAMESET.SCR_AGENCY], current_player),
          move = undefined,
          input = "";
      switch (current_agency) {
        // Tree
        case TEXT_GAMESET_AGENCY.MAIN_TREE:
          mcts_evaluate(tree, max_playout_plies, max_playout_ms, max_eval_playouts, max_eval_ms);
          move = mcts_get_best_move(tree);
          if (ai_verbose) {
						var _1 = script_execute(_scr_state_display, state),
								_2 = lflf,
								_3 = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], move),
								_4 = mcts_output_ranked_moves(tree, text_gameset, TEXT_OUTPUT.STRING, ai_verbose);
            gmst_output(ai_output, script_execute(_scr_state_display, state) + lflf + "Chosen move: " + script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], move) + lflf + mcts_output_ranked_moves(tree, text_gameset, TEXT_OUTPUT.STRING, ai_verbose));
          } else {
            mcts_output_ranked_moves(tree, text_gameset, ai_output, ai_verbose);
          }
          break;
        // Player input
        case TEXT_GAMESET_AGENCY.USER_INPUT:
          var recommendation = "";
          do {
            var available_moves = script_execute(ruleset[RULESET.SCR_GENERATE_MOVES], state);
            if (array_length_1d(available_moves) == 1) {
              recommendation = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], available_moves[0]);
            }
            input = get_string(script_execute(_scr_state_display, state) + lflf + "Move for " + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], current_player) + ":", recommendation);
            // 1.4.9999 hack: Solve crash involving pressing Cancel
            if (typeof(input) != "string" || string_length(input) == 0) {
              input = "";
            }
            // Special commands
            switch (string_lower(input)) {
              // Create a new tree and come up with a hint
              case ":hint":
                if (array_length_1d(available_moves) == 1) {
                  show_message("You have only one move: " + recommendation);
                } else {
                  var hint_tree = MctsTree(state, ruleset, configs);
                  mcts_evaluate(hint_tree, max_playout_plies, max_playout_ms, max_eval_playouts, max_eval_ms);
                  recommendation = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], mcts_get_best_move(hint_tree));
                  show_message(script_execute(_scr_state_display, state) + lflf + "Suggested Move: " + recommendation + lflf + mcts_output_ranked_moves(hint_tree, text_gameset, TEXT_OUTPUT.STRING, true));
                }
                continue;
              // Restart with the same opening game state
              case ":restart":
                if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
                  script_execute(ruleset[RULESET.SCR_CLEANUP], state);
                }
                tree[MCTS_TREE.ROOT] = undefined;
                tree = undefined;
                state = script_execute(ruleset[RULESET.SCR_DECODE], state_pickle);
                tree = MctsTree(state, ruleset, configs);
                show_message("Game restarted:" + lflf + script_execute(_scr_state_display, state) + lflf + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state)) + " plays first.");
                continue;
              // Start a new game with a new game state
              case ":newgame":
                if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
                  script_execute(ruleset[RULESET.SCR_CLEANUP], state);
                }
                tree[MCTS_TREE.ROOT] = undefined;
                tree = undefined;
                state = script_execute(_scr_new_game);
                state_pickle = script_execute(ruleset[RULESET.SCR_ENCODE], state);
                tree = MctsTree(state, ruleset, configs);
                show_message("New Game:" + lflf + script_execute(_scr_state_display, state) + lflf + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state)) + " plays first.");
                continue;
              // Finish playing without ending game
              case ":finish":
                if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
                  script_execute(ruleset[RULESET.SCR_CLEANUP], state);
                }
                tree[MCTS_TREE.ROOT] = undefined;
                tree = undefined;
                exit;
              // Finish playing and end game
              case ":quit":
                game_end();
                exit;
            }
            // Attempt to convert the move from the input
            move = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_INPUT], input);
            // If present, determine if the move is legal
            var move_legal = false;
            if (!is_undefined(move)) {
              move_legal = script_execute(ruleset[RULESET.SCR_IS_LEGAL], state, move);
              if (!move_legal) {
                show_message("That move is illegal.");
              }
            }
          // Keep trying to get input until a legal move is found or starting a new round
          } until (input == ":restart" || input == ":newgame" || (!is_undefined(move) && move_legal));
          break;
        // Script
        default:
          move = script_execute(current_agency, state);
          break;
      }
      // Go back immediately if restart or new game
      if (input == ":restart" || input == ":newgame") continue;
      // Apply the move to the state
      script_execute(ruleset[RULESET.SCR_APPLY_MOVE], state, move);
      // Re-root the tree
      var _move = array_create(1);
      _move[0] = move;
      mcts_reroot(tree, _move);
    }
    // Announce winner
    show_message(script_execute(_scr_state_display, state) + lflf + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYOUT_COMMENT], script_execute(ruleset[RULESET.SCR_PLAYOUT_RESULT], state)));
    // Clean up the state and the tree
    if (!is_undefined(ruleset[RULESET.SCR_CLEANUP])) {
      script_execute(ruleset[RULESET.SCR_CLEANUP], state);
    }
    tree[MCTS_TREE.ROOT] = undefined;
    tree = undefined;
  // Repeat until the player quits
  } until (!show_question("Play again?"));
}
