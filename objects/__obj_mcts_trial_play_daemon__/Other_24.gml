 /// @description Start the game
// Set up the state
state = script_execute(text_gameset[TEXT_GAMESET.SCR_NEW_GAME]);
state_pickle = script_execute(ruleset[RULESET.SCR_ENCODE], state);
tree = MctsTree(state, ruleset, configs);
// Notify start of game
var current_player = script_execute(ruleset[RULESET.SCR_CURRENT_PLAYER], state)
    lflf = chr(10)+chr(10);
mh_new_game = show_message_async("New game:" + lflf + script_execute(text_gameset[TEXT_GAMESET.SCR_STATE_DISPLAY], state) + lflf + script_execute(text_gameset[TEXT_GAMESET.SCR_PLAYER_NAME], current_player) + " plays first.");
