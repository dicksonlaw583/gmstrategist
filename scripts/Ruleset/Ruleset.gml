/// @description Ruleset(scr_decode, scr_encode, scr_cleanup, scr_is_final, scr_generate_moves, scr_current_player, scr_is_legal, scr_apply_move, scr_playout_result)
/// @param scr_decode
/// @param  scr_encode
/// @param  scr_cleanup
/// @param  scr_is_final
/// @param  scr_generate_moves
/// @param  scr_current_player
/// @param  scr_is_legal
/// @param  scr_apply_move
/// @param  scr_playout_result
/**
Ruleset[
  (SerializedState ps => State) SCR_DECODE, // Unpickle serialized state
  (State s => SerializedState) SCR_ENCODE // Pickle live state
  (@State s => -) SCR_CLEANUP, // Free the live state
  (State s => Bool), SCR_IS_FINAL // Return whether the state is a finished game
  (State s => Move[]) SCR_GENERATE_MOVES, // Generate all moves from the current state, without checking finality
  (State s => Player) SCR_CURRENT_PLAYER, // Return the current player of the state
  (State s, Move m => Bool) SCR_IS_LEGAL, // Return whether the move is legal
  (@State s, Move m => -) SCR_APPLY_MOVE, // Apply the move to the given state, without checking legality
  (State s => PlayoutResult) SCR_PLAYOUT_RESULT, // Return playout result (can be tentative or final)
]
*/
enum RULESET {
  SCR_DECODE,
  SCR_ENCODE,
  SCR_CLEANUP,
  SCR_IS_FINAL,
  SCR_GENERATE_MOVES,
  SCR_CURRENT_PLAYER,
  SCR_IS_LEGAL,
  SCR_APPLY_MOVE,
  SCR_PLAYOUT_RESULT,
}
{
	return [
		argument0,
		argument1,
		argument2,
		argument3,
		argument4,
		argument5,
		argument6,
		argument7,
		argument8
	];
}
