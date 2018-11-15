/// @description gmst_array_clone_deep(arr)
/// @param arr
/**
Return a recursive clone of the given array.
*/
{
  var _newarr;
  // 1D mode
  if (array_height_2d(argument0) == 1) {
    var _size = array_length_1d(argument0);
    _newarr = array_create(_size);
    for (var i = 0; i < _size; i++) {
      if (is_array(argument0[i])) {
        _newarr[i] = gmst_array_clone_deep(argument0[i]);
      } else {
        _newarr[i] = argument0[i];
      }
    }
  }
  // 2D mode
  else {
    for (var i = array_height_2d(argument0)-1; i >= 0; i--) {
      for (var j = array_length_2d(argument0, i); j >= 0; j--) {
        if (is_array(argument0[i, j])) {
          _newarr[i, j] = gmst_array_clone_deep(argument0[i, j]);
        } else {
          _newarr[i, j] = argument0[i, j];
        }
      }
    }
  }
  return _newarr;
}
