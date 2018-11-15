/// @description Check main tree daemon
{
if (instance_exists(evaluation_daemon)) {
  draw_healthbar(x, y, x+100, y+8, 100*evaluation_daemon.progress, c_black, c_white, c_white, 0, true, true);
}
}


///Check hint tree daemon
{
if (instance_exists(hint_evaluation_daemon)) {
  draw_healthbar(x, y, x+100, y+8, 100*hint_evaluation_daemon.progress, c_black, c_white, c_white, 0, true, true);
}
}


