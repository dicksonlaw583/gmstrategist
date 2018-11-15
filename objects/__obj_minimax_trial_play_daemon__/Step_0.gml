/// @description Check main tree daemon
{
if (evaluation_daemon != noone && evaluation_daemon.ready) {
  move = mm_get_best_move(tree);
  switch (ai_output) {
    // Asynchronous means of reporting: Wait for response first
    case TEXT_OUTPUT.MESSAGE_ASYNC:
    case TEXT_OUTPUT.COPYABLE_MESSAGE_ASYNC:
      if (ai_verbose) {
        mh_ai_thinks = gmst_output(ai_output, script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + lflf + "Chosen move: " + script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], move) + lflf + mm_output_ranked_moves(tree, text_gameset, TEXT_OUTPUT.STRING, ai_verbose));
      } else {
        mh_ai_thinks = mm_output_ranked_moves(tree, text_gameset, ai_output, ai_verbose);
      }
      break;
    // Synchronous means of reporting: Apply move right away
    default:
      if (ai_verbose) {
        gmst_output(ai_output, script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + lflf + "Chosen move: " + script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], move) + lflf + mm_output_ranked_moves(tree, text_gameset, TEXT_OUTPUT.STRING, ai_verbose));
      } else {
        mm_output_ranked_moves(tree, text_gameset, ai_output, ai_verbose);
      }
      event_user(1);
  }
  with (evaluation_daemon) instance_destroy();
  evaluation_daemon = noone;
}
}


///Check hint tree daemon
{
if (hint_evaluation_daemon != noone && hint_evaluation_daemon.ready) {
  recommendation = script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], mm_get_best_move(hint_tree));
  mh_hint = show_message_async(script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + chr(10) + chr(10) + "Suggested Move: " + recommendation + chr(10) + chr(10) + mm_output_ranked_moves(hint_tree, text_gameset, TEXT_OUTPUT.STRING, true));
  with (hint_evaluation_daemon) instance_destroy();
  hint_evaluation_daemon = noone;
  hint_tree[MCTS_TREE.ROOT] = undefined;
  hint_tree = undefined;
}
}


