
include<fasteners.scad>
include<steppers.scad>
include<bearings.scad>

$fn = 24;
pi = 3.1415926535897932384626433832795;

layer_height = 0.33;

d_guide_rods = 12;
d_rail_screws = d_M5_screw;

// drive belt
p_drive_belt = 2; // drive belt pitch
n_teeth = 18;
d_pulley = n_teeth * p_drive_belt / pi;
idler_bearing = bearing_624;

// y-direction component dims
l_y_bearing = 70;
w_y_bearing = 28;
h_y_bearing = 34;
d_y_bearing = 12;
cc_horizontal_mounts_y_bearing = 50;
cc_vertical_mounts_y_bearing = 36;

l_motor_mount = l_NEMA17 + 20;
w_motor_mount = l_NEMA17 + 20;
t_motor_mount = 4;
r_y_mount_corners = 8;
offset_x_ymotor = -8;
offset_y_ymotor = -8;

l_xclamp = l_y_bearing + d_guide_rods;
w_xclamp = w_y_bearing;
h_xclamp  = d_guide_rods + 8;
cc_x_guide_rods = cc_vertical_mounts_y_bearing + 2 * d_guide_rods;
l_clamp_gap = 20;

h_xmotor_mount = 12;
w_xmotor_mount = 3;
offset_ybelt = 15; // distance from edge of ybearing to nearest edge of belt
l_y_carriage = l_y_bearing;
w_y_carriage = 19;
h_y_carriage = 4;
x_offset_belt_mount = 13;
y_offset_belt_mount = -2;
h_x_idler_cap = 10;

// x-carriage dimensions
l_x_bearing = 40;
w_x_bearing = 28;
h_x_bearing = 34;
cc_horizontal_mounts_x_bearing = 15;
cc_vertical_mounts_x_bearing = 27;
offset_x_bearing_horizontal_mounts = 6;
x_offset_belt = 19; // distance from x-drive belt to the fixed terminator
t_x_carriage = x_offset_belt + 3;
h_x_carriage = h_x_bearing + t_x_carriage - x_offset_belt;
l_x_carriage = cc_x_guide_rods + w_x_bearing;
x_offset_z_screw = 8;
cc_z_screw_z_guide = (l_x_carriage + x_offset_z_screw) / 2 + x_offset_z_screw - (idler_bearing[0] /2 + 3.50);
d_z_guide_rod = 6;

// laser mount dimensions
od_laser_mount = 30.5;
id_laser_mount = 26.18;
h_laser_mount = 12.66;
d_laser_carriage = od_laser_mount + 8;
h_laser_carriage = h_laser_mount + 2;

module x_fixed_cable_mount() {
	difference() {
		union() {
			translate([0, -6, 0])
				cube([l_y_carriage, h_y_bearing, h_y_carriage], center = true);
			
			translate([x_offset_belt_mount, -15, -h_y_carriage / 2])
				hull()
					for (i = [-1, 1])
						translate([i * 9.38 / 2, 0, 0])
							cylinder(r = d_M3_screw / 2 + 4, h = 12);
		}
		
		for (i = [-1, 1])
			translate([i * cc_horizontal_mounts_y_bearing / 2, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([0, j * 5, 0])
							cylinder(r = d_M5_screw / 2, h = h_y_carriage + 1, center = true);

			translate([x_offset_belt_mount, -15, -h_y_carriage / 2])
				for (i = [-1, 1])
					translate([i * 9.38 / 2, 0, -1])
						cylinder(r = d_M3_screw / 2 - 0.25, h = 14);
	}
}

module x_carriage_cable_mount() {
	difference() {
		union() {
			cylinder(r = d_M6_screw / 2 + 3, h = 21, center = true);

			translate([12.5, d_M6_screw / 2 + 1.5, 0])
				cube([25, 3, 21], center = true);
		}

		cylinder(r = d_M6_screw / 2, h = 22, center = true);

// the screws on hand were too long for this pocket
//		translate([0, 0, 4.5])
//			cylinder(r = 5.5 , h = 7);

		rotate([90, 0, 0])
			for (i = [-1, 1])
				translate([i * 9.38 / 2 + 15, 0, 0])
					cylinder(r = d_M3_screw / 2, h = 2 * d_M6_screw, center = true);
	}
}

module controller_standoff() {
	// standoffs for mounting to 80-20 rail
	difference() {
		union() {
			hull()
				for (i = [-1, 1])
					translate([i * 6, 0, 0])
						cylinder(r = d_M5_screw / 2 + 2, h = 5, center = true);
		
				translate([-6, 0, 5.5])
					cylinder(r = d_M5_screw / 2 + 2, h = 14, center = true);
		}

		translate([6, 0, 0])
			cylinder(r = d_M5_screw / 2, h = 8, center = true);

		translate([-6, 0, 5.5])
			cylinder(r = d_M3_screw / 2 - 0.25, h = 15, center = true);
	}
}

module y_cable_mount() {
	// cable carrier mount for the y-axis, mid-frame
	l_y_cable_mount = 36;
	w_y_cable_mount = 23;
	h_y_cable_mount = 30;
	a_mount = 10;

	union() {	
		difference() {
			cube([l_y_cable_mount, w_y_cable_mount, h_y_cable_mount], center = true);

			translate([0, 0, -1.5])
				cube([l_y_cable_mount + 1, w_y_cable_mount - 6, h_y_cable_mount - 9], center = true);

			translate([l_y_cable_mount / 2 - 5, 0, 0])
				cylinder(r = d_M5_screw / 2, h = h_y_cable_mount + 1, center = true);
				
			translate([l_y_cable_mount - 10, 0, 3])
				cube([l_y_cable_mount, w_y_cable_mount + 1, h_y_cable_mount], center = true);
		
			translate([0, 0, h_y_cable_mount - w_y_cable_mount * tan(a_mount) / 2])
				rotate([a_mount, 0, 0]) {
					cube([l_y_cable_mount + 1, l_y_cable_mount, h_y_cable_mount], center = true);
				
					for (i = [-1, 1])
						translate([i * 9.38 / 2 - 5, i * 2.5 - 2, -h_y_cable_mount / 2]) {
							cylinder(r = d_M3_screw / 2, h = 15, center = true);

							translate([0, 0, -5])
								cylinder(r = d_M3_nut / 2, h = 5, center = true, $fn = 6);
						}
				}
		}
		
		// add a floor under the nut pockets
		translate([-5, 0, (h_y_cable_mount - 9) / 2 - 1.5 + layer_height / 2])
			cube([l_y_cable_mount - 10, w_y_cable_mount, layer_height], center = true);
	}
}

module x_motor_saddle_cable_carrier_mount() {	
	// combine an x-motor saddle with a mount for the cable carrier:
	difference() {
		union() {
			translate([0, 0, h_xclamp / 2])
				x_motor_saddle();
		
			translate([-l_NEMA17 / 2, 3, 0])
				cube([l_NEMA17, 30, 3]);
		}
	
	for (i = [-1, 1])
		translate([i * 9.38 / 2, 20 + i * 2.5, -1])
			cylinder(r = d_M3_screw / 2, h = 5);
	}
}

module limit_switch_mount() {
	// limist switch holder
	cc_switch_mounts = 9.4;
	d_switch_screws = 1.7;
	h_switch_mount = 8;
	difference() {
		hull()
			for (i = [0, 1])
				translate([i * d_guide_rods, 0, 0])
					cylinder(r = d_guide_rods / 2 + 2.5, h = h_switch_mount, center = true);

		translate([2.5 * d_guide_rods + 2, 0, 0])
			cube([4 * d_guide_rods, 4 * d_guide_rods, h_switch_mount + 1], center = true);

		cylinder(r = d_guide_rods / 2 + 0.25, h = d_guide_rods + 5, center = true);
		
		translate([d_guide_rods / 2 + 2.5, 2, 0])
			rotate([0, 90, 0])
				for (i = [-1, 1])
					translate([0, i * cc_switch_mounts / 2, 0])
						cylinder(r = d_switch_screws / 2, h = 15, center = true);
		
		translate([d_guide_rods / 2 - 0.25, d_guide_rods / 2, 0])
			cube([0.5, d_guide_rods, h_switch_mount + 1], center = true);
	}
}

module M8_thumbscrew() {
	od_thumbscrew = d_M8_nut + 16;
	difference() {
		cylinder(r = od_thumbscrew / 2, h = h_M8_nut + 2, center = true);
		
		for (i = [0:15])
			rotate([0, 0, i * 360 / 16])
				translate([od_thumbscrew / 2, 0, 0])
					cylinder(r = 1, h = h_M8_nut + 3, center = true);

		translate([0, 0, 2])
			cylinder(r = d_M8_nut / 2, h = h_M8_nut + 2, center = true, $fn = 6);

		cylinder(r = d_M8_screw / 2, h = h_M8_nut + 3, center = true);
	}
}

module laser_carriage() {
	difference() {
		hull() {
			translate([-cc_z_screw_z_guide / 2, 0, 0])
				cylinder(r = d_z_guide_rod / 2 + 4, h = h_laser_carriage, center = true);
			
			cylinder(r = d_laser_carriage / 2, h = h_laser_carriage, center = true);

			translate([cc_z_screw_z_guide / 2, 0, 0])
				cylinder(r = d_M8_screw / 2 + 5, h = h_laser_carriage, center = true);
		}
		
		// pocket for laser
		translate([0, 0, 2])
			cylinder(r = od_laser_mount / 2 + 0.1, h = h_laser_carriage, center = true);
		
		cylinder(r = id_laser_mount / 2 , h = h_laser_carriage + 1, center = true);
		
		// z-screw
		translate([cc_z_screw_z_guide / 2, 0, 0]) {
			translate([0, 0, h_M8_nut + 0.33])
				cylinder(r = d_M8_screw / 2, h = h_laser_carriage, center = true);

			translate([0, 0, -h_laser_carriage / 2])
				rotate([0, 0, 30])
					cylinder(r = d_M8_nut / 2, h = h_M8_nut, $fn = 6);
		}

		// z-guide rod
		translate([-cc_z_screw_z_guide / 2, 0, 5])
			cylinder(r = d_z_guide_rod / 2, h = h_laser_carriage + 1, center = true);

		// mounts for laser mounting cap
		rotate([0, 0, 30])
			for (i = [-1, 1])
				translate([i * ((od_laser_mount + d_M3_screw) / 2 + 0.7), 0, 0])
					cylinder(r = d_M3_screw / 2 - 0.25, h = h_laser_carriage + 1, center = true);
	}
}

module x_carriage() {
	difference() {
		union() {
			cube([l_x_carriage, l_x_bearing, t_x_carriage], center = true);
		
			translate([(l_x_carriage + x_offset_z_screw) / 2, 0, (h_x_bearing - x_offset_belt) / 2])
				hull() {
					translate([-x_offset_z_screw / 2, 0, 0])
						cube([0.1, l_x_bearing, h_x_carriage], center = true);

					translate([x_offset_z_screw, 0, 0])
						cylinder(r = d_M8_screw / 2 + 3, h = h_x_carriage, center = true);
				}

			// horizontal bearing mounts
			rotate([0, 90, 0])
				for (i = [-1, 1])
					translate([x_offset_belt - t_x_carriage / 2 - offset_x_bearing_horizontal_mounts, i * cc_horizontal_mounts_x_bearing / 2, (l_x_carriage + x_offset_z_screw) / 2]) {
						cylinder(r = d_M5_screw / 2 + 3, h = 4 * x_offset_z_screw, center = true);
						
						translate([3.35, 0, 0])
							cube([d_M5_screw + 6, 1, 4 * x_offset_z_screw], center = true);
					}
		}
		
		// vertical bearing mounts
		for (i = [-1, 1])
			for (j = [-1, 1])
				translate([j * cc_x_guide_rods / 2, i * cc_vertical_mounts_x_bearing / 2, 0])
					cylinder(r = d_M6_screw / 2, h = t_x_carriage + 1, center = true);
		
		for (i = [-1, 1])
			translate([i * cc_x_guide_rods / 2, 0, t_x_carriage - x_offset_belt])
				cube([w_x_bearing, l_x_bearing + 1, t_x_carriage], center = true);
		
		// horizontal bearing mounts
		rotate([0, 90, 0])
			for (i = [-1, 1])
				translate([x_offset_belt - t_x_carriage / 2 - offset_x_bearing_horizontal_mounts, i * cc_horizontal_mounts_x_bearing / 2, (l_x_carriage + x_offset_z_screw) / 2]) {
					cylinder(r = d_M5_screw / 2, h = 4 * x_offset_z_screw + 1, center = true);
				}

		// z-screw
		translate([(l_x_carriage + x_offset_z_screw) / 2 + x_offset_z_screw, 0, (h_x_bearing - x_offset_belt) / 2])
			cylinder(r = d_M8_screw / 2 + 0.2, h = h_x_carriage + 1, center = true);
		
		// belt terminator mount
		translate([-d_pulley / 2, 15, h_M3_nut + 0.33])
			cylinder(r = d_M3_screw / 2, h = t_x_carriage, center = true);
		
		translate([0, 0, 2])
			difference() {
				round_box(
					length = l_x_carriage - 2 * w_x_bearing - 4,
					width = l_x_bearing - 4,
					height = t_x_carriage,
					corner_radius = 2
				);

				translate([-d_pulley / 2, 15, 0])
					cylinder(r = d_M3_screw / 2 + 3.5, h = t_x_carriage + 1, center = true);
			
				translate([idler_bearing[0] / 2 + 3.50, , 0])
					cylinder(r = d_z_guide_rod / 2 + 4, h = t_x_carriage +1, center = true);
			}
		
		translate([-d_pulley / 2, 15, -t_x_carriage / 2])
			cylinder(r = d_M3_nut / 2, h = h_M3_nut, $fn = 6);
			
		// 6mm z-guide rod
		translate([idler_bearing[0] / 2 + 3.50, , 0])
			cylinder(r = d_z_guide_rod / 2 + 0.1, h = t_x_carriage +1, center = true);
	}
}

module x_motor_saddle() {
		difference() {
			cube([l_xclamp, 8, h_xclamp], center = true);
		
			// guide rod pockets
			rotate([90, 0, 0])
				for (i = [-1, 1])
					translate([i * cc_x_guide_rods / 2, 0, 0])
						cylinder(r = d_guide_rods / 2, h = w_xclamp + 1, center = true);
			
			translate([0, 0, h_xclamp / 2])
				cube([l_xclamp + 1, 9, h_xclamp], center = true);

			translate([0, 0, 3])
				cube([l_NEMA17, 9, h_xclamp], center = true);
			
			for (i = [-1, 1])
				translate([i * cc_NEMA17_mount / 2, 0, 0])
					cylinder(r = d_M3_screw / 2, h = h_xclamp + 1, center = true);
		}

}

module x_idler_cap() {
	difference() {
		union() {
			hull()
				for (i = [-1, 1])
					translate([i * cc_vertical_mounts_y_bearing / 2, 0, 0])
						cylinder(r = d_M6_screw / 2 + 7, h = h_x_idler_cap, center = true);

			// standoffs for optical endstop
			for (i = [-1, 1])
				translate([i * 19 / 2, 7, 0.5])
					cylinder(r = d_M3_screw / 2 + 1.5, h = h_x_idler_cap + 1, center = true);
		}
		
		// pockets for mounting to bearing/xclamp
		for (i = [-1, 1])
			translate([i * cc_vertical_mounts_y_bearing / 2, 0, 0]) {
				cylinder(r = d_M6_screw / 2, h = h_x_idler_cap + 1, center = true);

				translate([0, 0, 3])
					cylinder(r = 6, h = h_x_idler_cap, center = true);
			}

		// pockets for optical endstop mounting
		for (i = [-1, 1])
			translate([i * 19 / 2, 7, 3])
				cylinder(r = d_M3_screw / 2 - 0.25, h = h_x_idler_cap + 1, center = true);
				
		// hole for idler shaft
		cylinder(r = idler_bearing[1] / 2, h = h_x_idler_cap + 1, center = true);
	}
}

module y_carriage() {
	difference() {
		union() {
			cube([l_y_carriage, w_y_carriage, h_y_carriage], center = true);
			
			translate([x_offset_belt_mount, y_offset_belt_mount, -h_y_carriage / 2])
				cylinder(r = d_M3_nut / 2 + 4, h = offset_ybelt);
		}
		
		for (i = [-1, 1])
			translate([i * cc_horizontal_mounts_y_bearing / 2, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([0, j * 3, 0])
							cylinder(r = d_M5_screw / 2, h = h_y_carriage + 1, center = true);

			translate([x_offset_belt_mount, y_offset_belt_mount, offset_ybelt - h_y_carriage / 2 - 5])
				cube([5.6, 15, h_M3_nut], center = true);

			translate([x_offset_belt_mount, y_offset_belt_mount, 0])
				cylinder(r = d_M3_screw / 2, h = 2 * offset_ybelt + 1, center = true);
	}
}

module xmotor_mount() {
	difference() {
		union() {
			cube([l_y_bearing, w_xmotor_mount, h_xmotor_mount], center = true);

			translate([0,(l_NEMA17 + 6) / 2, (w_xmotor_mount - h_xmotor_mount) / 2])
				difference() {
					cube([l_NEMA17 + 3, l_NEMA17 + 3, w_xmotor_mount], center = true);
			
					NEMA_parallel_mount(
						height = w_xmotor_mount + 1,
						l_slot = 0,
						motor = NEMA17
					);
				}
		}
		
		rotate([90, 0, 0])
			for (i = [-1, 1])
				translate([i * cc_horizontal_mounts_y_bearing / 2, 6 - h_xmotor_mount / 2, 0])
					cylinder(r = d_M5_screw / 2, h = 5, center = true);
	}
}

module xclamp() {
	rotate([90, 0, 0])
		difference() {
			cube([l_xclamp, w_xclamp, h_xclamp], center = true);
		
			// guide rod pockets
			rotate([90, 0, 0])
				for (i = [-1,1])
					translate([i * cc_x_guide_rods / 2, 0, 0])
						cylinder(r = d_guide_rods / 2, h = w_xclamp + 1, center = true);
					
			// bearing mount pockets
			for (i = [-1,1])
				translate([i * cc_vertical_mounts_y_bearing / 2, 0, 0])
					cylinder(r = d_M6_screw / 2, h = h_xclamp + 1, center = true);

			translate([0, 0, h_xclamp / 2 - 0.5])
				cube([(cc_x_guide_rods - l_clamp_gap) / 2, w_xclamp + 1, h_xclamp], center = true);

			// relief for compression of clamps
			for (i = [0, 1])
				mirror([i, 0, 0])
					translate([(cc_x_guide_rods - l_clamp_gap) / 2, 0, 0])
						cube([l_clamp_gap, w_xclamp + 1, 1], center = true);

			// hole for mounting an idler shaft
			cylinder(r = d_M4_screw / 2, h = h_xclamp + 1, center = true);

			translate([0, 0, -h_xclamp / 2 - 0.5])
				cylinder(r = d_M4_nut / 2, h = h_M4_nut + 1, $fn = 6);
		}
}

module y_idler(
	corner_knockout = false
) {
	difference() {
		y_drive_mount();
	
		translate([offset_x_ymotor + (idler_bearing[0] - d_pulley) / 2, offset_y_ymotor + (idler_bearing[0] - d_pulley) / 2, 0])
			cylinder(r = idler_bearing[1] / 2, h = t_motor_mount + 1, center = true);

		for (i = [-1, 1])
			translate([i * (l_motor_mount / 2 - r_y_mount_corners), (w_motor_mount / 2 - r_y_mount_corners), 0])
					cylinder(r = d_rail_screws / 2, h = t_motor_mount + 1, center = true);
		
		translate([(l_motor_mount / 2 - r_y_mount_corners), -(w_motor_mount / 2 - r_y_mount_corners), 0])
			cylinder(r = d_rail_screws / 2, h = t_motor_mount + 1, center = true);

		if (corner_knockout)
			translate([(l_motor_mount / 2 - r_y_mount_corners - 2), (w_motor_mount / 2 - r_y_mount_corners - 2), 0])
				cube([21, 21, t_motor_mount + 1], center = true);
		
	}
}

module y_motor_mount() {
	difference() {
		y_drive_mount();
	
		translate([offset_x_ymotor, offset_y_ymotor, 0])
			NEMA_parallel_mount(
				height = t_motor_mount + 1,
				l_slot = 0,
				motor = NEMA17
			);

		for (i = [-1, 1])
			translate([i * (l_motor_mount / 2 - r_y_mount_corners), (w_motor_mount / 2 - r_y_mount_corners), 0])
					cylinder(r = d_rail_screws / 2, h = t_motor_mount + 1, center = true);
		
		translate([(l_motor_mount / 2 - r_y_mount_corners), -(w_motor_mount / 2 - r_y_mount_corners), 0])
			cylinder(r = d_rail_screws / 2, h = t_motor_mount + 1, center = true);
		
	}
}

module y_drive_mount() {
	round_box(
		length = l_motor_mount,
		width = w_motor_mount,
		height = t_motor_mount,
		corner_radius = r_y_mount_corners
	);
}

module round_box(
	length,
	width,
	height,
	corner_radius
){
	hull()
		for (i = [-1, 1])
			for (j = [-1, 1])
				translate([i * (length / 2 - corner_radius), j * (width / 2 - corner_radius), 0])
					cylinder(r = corner_radius, h = height, center = true);
}
