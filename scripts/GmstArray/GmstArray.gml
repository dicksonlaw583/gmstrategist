/// @description GmstArray(...)
/// @param ...
/**
Return 1D array with given elements
*/
{
  var _array = array_create(argument_count);
  for (var i = argument_count-1; i >= 0; i--) {
    _array[i] = argument[i];
  }
  return _array;
}
