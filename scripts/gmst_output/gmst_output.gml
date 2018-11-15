/// @description gmst_output(target_content, text)
/// @param target_content
/// @param  text
/**
Put the given content in string form to the given target.
The target can be a string for a file, or any of the following values:
- TEXT_OUTPUT.STRING: Return as string.
- TEXT_OUTPUT.DEBUG: show_debug_message()
- TEXT_OUTPUT.MESSAGE: show_message()
- TEXT_OUTPUT.MESSAGE_ASYNC: show_message_async() (given as return value)
- TEXT_OUTPUT.COPYABLE_MESSAGE: get_string() (part of default text)
- TEXT_OUTPUT.COPYABLE_MESSAGE_ASYNC: get_string_async() (part of default text, given as return value)
- TEXT_OUTPUT.ERROR: show_error() (no abort)
- TEXT_OUTPUT.ERROR_ABORT: show_error() (forced abort)
*/
enum TEXT_OUTPUT {
  STRING = -1,
  DEBUG = -2,
  MESSAGE = -3,
  MESSAGE_ASYNC = -4,
  COPYABLE_MESSAGE = -5,
  COPYABLE_MESSAGE_ASYNC = -6,
  ERROR = -7,
  ERROR_ABORT = -8
}
{
  // Capture parameters
  var text = string(argument1),
      output = argument0;
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
