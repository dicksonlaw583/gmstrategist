/// @description Configuration
{
min_slice = 10;
step_time_limit = 500/room_speed;
native_congestion_factor = 2;
native_congestion_cut = 0.5;
native_slow_start_increment = 10/room_speed;
html5_congestion_factor = 0.9;
html5_congestion_cut = 0.5;
html5_slow_start_increment = 20/room_speed;
}

///Setup
{
tree = undefined;
ready = false;
congestion_factor = undefined;
congestion_cut = undefined;
slow_start_increment = undefined;
max_playout_plies = undefined;
max_playouts = undefined;
max_playout_ms = undefined;
max_ms = undefined;
progress = 0;
elapsed_playouts = 0;
elapsed_ms = 0;
callback = undefined;
callback_arg = undefined;
}

