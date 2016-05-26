// parts for the laser plastic welder

include<laser_welder.scad>

// [l, w, h] = [x, y, z]

render_part(part_to_render = 15);

module render_part(part_to_render) {
	if (part_to_render == 1) y_motor_mount();
	
	if (part_to_render == 2) y_idler(corner_knockout = false);
	
	if (part_to_render == 3) xclamp();
	
	if (part_to_render == 4) xmotor_mount();
	
	if (part_to_render == 5) y_carriage();
	
	if (part_to_render == 6) x_idler_cap();
	
	if (part_to_render == 7) x_carriage();

	if (part_to_render == 8) x_motor_saddle_cable_carrier_mount();

	if (part_to_render == 9) y_cable_mount();

	if (part_to_render == 10) controller_standoff();
	
	if (part_to_render == 11) x_carriage_cable_mount();
	
	if (part_to_render == 12) x_fixed_cable_mount();

	if (part_to_render == 13) limit_switch_mount();
	
	if (part_to_render == 14) M8_thumbscrew();

	if (part_to_render == 15) laser_carriage();

	if (part_to_render == 99) sandbox();
}

module sandbox() {

}

