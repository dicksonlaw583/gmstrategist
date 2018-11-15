/// @description GmstArray2(height, length, ...)
/// @param height
/// @param  length
/// @param  ...
/**
Return 2D array in row-major interpretation
*/
{
  var _array2, _current;
  _current = argument_count;
  for (var i = argument[0]-1; i >= 0; i--) {
    for (var j = argument[1]-1; j >= 0; j--) {
      _array2[i, j] = argument[--_current];
    }
  }
  return _array2;
}
