/// @description TextGameset(scr_new_game, scr_agency, scr_player_name, scr_state_display, scr_move_output, scr_move_input, scr_playout_comment)
/// @param scr_new_game
/// @param  scr_agency
/// @param  scr_player_name
/// @param  scr_state_display
/// @param  scr_move_output
/// @param  scr_move_input
/// @param  scr_playout_comment
/**
TextGameset[
  (- => State) SCR_NEW_GAME, // Return a new game state
  (Player p => -2|-1|(State => Move)) SCR_AGENCY, // Return what plays as the given player (-2 = tree, -1 = player, any other for script)
  (Player p => String) SCR_PLAYER_NAME, // Return the name of the player
  (State s => String) SCR_STATE_DISPLAY, // Return a string representation of the game state
  (Move m => String) SCR_MOVE_OUTPUT, // Return the string equivalent of the given move
  (String s => Move|undefined) SCR_MOVE_INPUT, // Return the move equivalent of the given string (undefined if not valid)
  (PlayoutResult pr => String) SCR_PLAYOUT_COMMENT // Return a comment for the playout result
]
*/
enum TEXT_GAMESET {
  SCR_NEW_GAME,
  SCR_AGENCY,
  SCR_PLAYER_NAME,
  SCR_STATE_DISPLAY,
  SCR_MOVE_OUTPUT,
  SCR_MOVE_INPUT,
  SCR_PLAYOUT_COMMENT
}
enum TEXT_GAMESET_AGENCY {
  MAIN_TREE = -2,
  USER_INPUT = -1
}
{
	return [
		argument0,
		argument1,
		argument2,
		argument3,
		argument4,
		argument5,
		argument6
	];
}
