include <pir-power-usb-common.scad>

module bottom_holes() {
    translate([width - usb_margin_left - usb_width, length, usb_height_start]) {
        cube([usb_width, wall, height_bottom - usb_height_start + rim]);
    }
    translate([usb_margin_right, length, usb_height_start]) {
        cube([usb_width, wall, height_bottom - usb_height_start + rim]);
    }

    translate([width - (micro_usb_width + micro_usb_margin_left), -wall, micro_usb_height_start]) {
        cube([micro_usb_width, wall, height_bottom - micro_usb_height_start + rim]);
    }
}

module bottom_enclosure_base() {
    difference() {
        enclosure_rim(width, length, height_bottom, false);
        bottom_holes();
    }
}

module bottom_stands() {
    if (!use_screw_holes) {
        cylinder_stand_hole(3.05, 17.3, 0, height_bottom, hole_radius, stand_height, stand_radius);
    }
    cylinder_stand_hole(width - 3.1, 15.95, 0, 10, hole_radius, stand_height, stand_radius);

    cylinder_stand_hole(18.25, length - 4.2, 0, usb_height_start, hole_radius, stand_height, stand_radius);
    cylinder_stand_hole(width - 8.25, length - 4.2, 0, usb_height_start, hole_radius, stand_height, stand_radius);
}

module bottom_screw_holes() {
    if (use_screw_holes) {
        cylinder_stand_hole(3.05, 17.3, 0, height, hole_radius, stand_height, stand_radius, hole_height);

        cylinder_stand_hole(width - edge_margin, length - edge_margin, 0, height, hole_radius, stand_height, stand_radius, hole_height);
        cylinder_stand_hole(edge_margin, length - edge_margin, 0, height, hole_radius, stand_height, stand_radius, hole_height);
    }
}

module bottom_enclosure() {
    union() {
        bottom_enclosure_base();
        bottom_stands();
        bottom_screw_holes();
    }
}

bottom_enclosure();
