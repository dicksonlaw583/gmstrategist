/// @description GmstLattice(width, height, ...)
/// @param width
/// @param  height
/// @param  ...
/**
Return 2D array in column-major interpretation
*/
{
  var lattice, current;
  current = argument_count;
  for (var j = argument[1]-1; j >= 0; j--) {
    for (var i = argument[0]-1; i >= 0; i--) {
      lattice[i, j] = argument[--current];
    }
  }
  return lattice;
}
