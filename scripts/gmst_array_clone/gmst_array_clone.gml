/// @description gmst_array_clone(arr)
/// @param arr
/**
Return a shallow clone of the given array.
*/
{
  var _newarr;
  // 1D mode
  if (array_height_2d(argument0) == 1) {
    var _len = array_length_1d(argument0);
    _newarr = array_create(_len);
    array_copy(_newarr, 0, argument0, 0, _len);
  }
  // 2D mode
  else {
    for (var i = array_height_2d(argument0)-1; i >= 0; i--) {
      for (var j = array_length_2d(argument0, i); j >= 0; j--) {
        _newarr[i, j] = argument0[i, j];
      }
    }
  }
  return _newarr;
}
