$fn = 120;

width = 53.4 + 1;
length = 69.1 + 2.5;
height = 2.5 + 37 + 3.5;
height_bottom = 19;
height_top = height - height_bottom;

wall = 2;
rim = 1;

stand_radius = 2;
stand_height = 2.5;
hole_radius = 1.25; // 1.5
hole_smaller_radius = 1; // 1.25
hole_height = 0.4;
screw_head_radius = 1.95;
screw_thread_radius = 0.75;
edge_margin = hole_radius - screw_thread_radius / 2;

usb_width = 15.5;
usb_height = 8.5;
usb_margin_left = 7.5;
usb_margin_right = 7;
usb_height_start = stand_height + 1.75;

micro_usb_width = 10;
micro_usb_height = 4;
micro_usb_margin_left = 16.5; // ~16
micro_usb_height_start = stand_height + 9.5;

pir_side = 23.2;
pir_hole_radius = 1;
pir_screw_margin = 3;

use_screw_holes = false;

module enclosure(w, l, h) {
    difference() {
        translate([-wall, -wall, -wall]) {
            cube([w+wall*2, l+wall*2, h+wall]);
        }
        cube([w, l, h]);
    }
}

module rim(w, l, h) {
    translate([0, 0, h - rim]) {
        difference() {
            translate([-rim, -rim, 0]) {
                cube([w + rim*2, l + rim*2, rim]);
            }
            cube([w, l, rim]);
        }
    }
}

module enclosure_rim(w, l, h, inner=false) {
    if (inner) {
        difference() {
            enclosure(w, l, h);
            rim(w, l, h);
        }
    } else {
        union() {
            enclosure(w, l, h);
            rim(w, l, h+rim);
        }
    }
}

module cylinder_stand_hole(x, y, z, h, r, sh, sr, hh=0.0) {
    translate([x, y, z]) {
        union() {
            difference() {
                cylinder(h=h, r=r);
                if (hh > 0) {
                    translate([0, 0, h * (1.0 - hh)]) {
                        cylinder(h=h * hh, r=screw_thread_radius);
                    }
                }
            }
            cylinder(h=sh,r=sr);
        }
    }
}

module screw_hole(x, y) {
    translate([x, y, -wall]) {
        cylinder(h=wall, r1=screw_head_radius, r2=screw_thread_radius);
    }
}

