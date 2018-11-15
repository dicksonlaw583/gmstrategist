/// @description MmConfigs(scr_polarity, scr_heuristic, scr_interpret_result)
/// @param scr_polarity
/// @param  scr_heuristic
/// @param  scr_interpret_result
/**
Build a new set of Minimax configurations.

MmConfigs[
  (Player p, State s, ? arg => -1|1) SCR_POLARITY, // Return -1 if the player is minimizing, 1 if the player is maximizing
  ? ARG_POLARITY, // Arguments to pass to scr_polarity
  (State s, ? arg => Real) SCR_HEURISTIC, // The heuristic for evaluating a state
  ? ARG_HEURISTIC, // Arguments to pass to the heuristic
  (PlayoutResult pr, State s, ? arg => Real) SCR_INTERPRET_RESULT, // Return the reward according to the playout
  ? ARG_INTERPRET_RESULT // Arguments to pass to scr_interpret_result
]
*/
enum MM_CONFIGS {
  SCR_POLARITY,
  ARG_POLARITY,
  SCR_HEURISTIC,
  ARG_HEURISTIC,
  SCR_INTERPRET_RESULT,
  ARG_INTERPRET_RESULT
}
{
  var _configs = array_create(6);
  // For each argument:
  for (var i = 0; i < 3; i++) {
    var _arg = argument[i];
    // If the argument is an array:
    if (is_array(_arg)) {
      // First entry is the script
      _configs[i << 1] = _arg[0];
      // If the array is 3 entries or more, the slice [1..n-1] is the parameter
      var _arglen = array_length_1d(_arg);
      if (_arglen > 2) {
        var _configarg = array_create(_arglen-1);
        array_copy(_configarg, 0, _arg, 1, _arglen-1);
        _configs[(i<<1)+1] = _configarg;
      }
      // Otherwise, the second entry is the parameter
      else {
        _configs[(i<<1)+1] = _arg[1];
      }
    }
    // Otherwise, the provided argument is the script, and the parameter is undefined
    else {
      _configs[i << 1] = _arg;
      _configs[(i<<1)+1] = undefined;
    }
  }
  // Done
  return _configs;
}
