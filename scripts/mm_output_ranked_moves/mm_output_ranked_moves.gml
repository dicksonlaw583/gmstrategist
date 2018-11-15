/// @description mm_output_ranked_moves(tree, text_gameset, output, verbose)
/// @param tree
/// @param  text_gameset
/// @param  output
/// @param  verbose
/**
Output information on immediate next moves in descending order of value to the given target. For debug use.
Verbose output contains value info. Non-verbose output is moves only.
The output can be a string for a file, or any of the following:
- TEXT_OUTPUT.STRING: Return as string.
- TEXT_OUTPUT.DEBUG: show_debug_message()
- TEXT_OUTPUT.MESSAGE: show_message()
- TEXT_OUTPUT.MESSAGE_ASYNC: show_message_async() (given as return value)
- TEXT_OUTPUT.COPYABLE_MESSAGE: get_string() (part of default text)
- TEXT_OUTPUT.COPYABLE_MESSAGE_ASYNC: get_string_async() (part of default text, given as return value)
- TEXT_OUTPUT.ERROR: show_error() (no abort)
- TEXT_OUTPUT.ERROR_ABORT: show_error() (forced abort)
*/
{
  // Capture parameters
  var tree = argument0,
      text_gameset = argument1,
      output = argument2,
      verbose = argument3,
      text = "";
  // Line ending
  var eol = chr(10);
  // Verbose output
  var data = mm_get_ranked_moves_verbose(argument0),
      moves = array_height_2d(data);
  if (verbose) {
    for (var i = 0; i < moves; i++) {
      text += string(i+1) + ": " + script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], data[i, 0]) + " (W=" + string(data[i, 1]) + ")" + eol;
    }
  }
  // Concise output
  else {
    for (var i = 0; i < moves; i++) {
      text += string(i+1) + ": " + script_execute(text_gameset[TEXT_GAMESET.SCR_MOVE_OUTPUT], data[i, 0]) + eol;
    }
  }
  // Output to return, debug, message, error or script
  if (is_real(output)) {
    switch (output) {
      case TEXT_OUTPUT.STRING:
        return text;
      case TEXT_OUTPUT.DEBUG:
        show_debug_message(text);
        break;
      case TEXT_OUTPUT.MESSAGE:
        show_message(text);
        break;
      case TEXT_OUTPUT.MESSAGE_ASYNC:
        return show_message_async(text);
      case TEXT_OUTPUT.COPYABLE_MESSAGE:
        get_string("Ranked moves:", text);
      break;
      case TEXT_OUTPUT.COPYABLE_MESSAGE_ASYNC:
        return get_string_async("Ranked moves:", text);
      case TEXT_OUTPUT.ERROR:
        show_error(text, false);
        break;
      case TEXT_OUTPUT.ERROR_ABORT:
        show_error(text, true);
        break;
      default:
        script_execute(output, text);
        break;
    }
  }
  // Output to file
  else if (is_string(output)) {
    var f = file_text_open_write(output);
    file_text_write_string(f, text);
    file_text_close(f);
  }
}
