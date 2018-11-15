/// @description Set the correct congestion control parameters
{
if (os_browser == browser_not_a_browser) {
  congestion_factor = native_congestion_factor;
  congestion_cut = native_congestion_cut;
  slow_start_increment = native_slow_start_increment;
} else {
  congestion_factor = html5_congestion_factor;
  congestion_cut = html5_congestion_cut;
  slow_start_increment = html5_slow_start_increment;
}
}

