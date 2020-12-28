include <pir-power-usb-common.scad>

module top_enclosure_base() {
    difference() {
        union() {
            enclosure_rim(width, length, height_top, true);
            top_hole_fills();
        }
        bottom_stand_holes();
        top_screw_holes();
        top_pir();
        top_pir_screw_holes();
    }
}

module bottom_stand_holes() {
    if (use_screw_holes) {
        translate([edge_margin, length-edge_margin, 0]) {
            cylinder(h=height, r=hole_radius);
        }
        translate([width-edge_margin, length-edge_margin]) {
            cylinder(h=height, r=hole_radius);
        }
    }
}

module top_hole_fills() {
    translate([usb_margin_left, length, height_top - rim]) {
        cube([usb_width, wall, height_bottom - usb_height_start - usb_height + rim]);
    }
    translate([width - usb_margin_right - usb_width, length, height_top - rim]) {
        cube([usb_width, wall, height_bottom - usb_height_start - usb_height + rim]);
    }

    translate([micro_usb_margin_left, -wall, height_top - rim]) {
        cube([micro_usb_width, wall, height_bottom - micro_usb_height_start - micro_usb_height + rim]);
    }
}

module top_screw_holes() {
    if (use_screw_holes) {
        screw_hole(width - 3.05, 17.3);

        screw_hole(width - edge_margin, length - edge_margin);
        screw_hole(edge_margin, length - edge_margin);
    }
}

module top_pir() {
    translate([width/2 - pir_side/2, length/2 - pir_side/2, -wall]) {
        cube([pir_side, pir_side, wall]);
    }
}

module top_pir_stands() {
    if (!use_screw_holes) {
        cylinder_stand_hole(width/2, length/2 - pir_side/2 - pir_screw_margin, 0, 3, pir_hole_radius * 0.75, 1, stand_radius);
        translate([width/2, length/2 - pir_side/2 - pir_screw_margin, 3]) {
            sphere(pir_hole_radius);
        }
        cylinder_stand_hole(width/2, length/2 + pir_side/2 + pir_screw_margin, 0, 3, pir_hole_radius * 0.75, 1, stand_radius);
        translate([width/2, length/2 + pir_side/2 + pir_screw_margin, 3]) {
            sphere(pir_hole_radius);
        }
    }
}

module top_pir_screw_holes() {
    if (use_screw_holes) {
        screw_hole(width/2, length/2 - pir_side/2 - pir_screw_margin);
        screw_hole(width/2, length/2 + pir_side/2 +  pir_screw_margin);
    }
}

module top_stands() {
    cylinder_stand_hole(width - 18, length - 3.5, 0, 31, hole_smaller_radius, 26, stand_radius);
}

module top_enclosure() {
    union() {
        top_enclosure_base();
        top_pir_stands();
        top_stands();
    }
}

top_enclosure();
