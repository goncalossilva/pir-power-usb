include <pir-power-usb-common.scad>
use <pir-power-usb-bottom.scad>
use <pir-power-usb-top.scad>

bottom_enclosure();
translate([width + wall * 5, 0, 0]) {
    top_enclosure();
}

/*// Debug
translate([width, 0, height * 1.5]) {
    rotate([0, 180, 0]) {
        top_enclosure();
    }
}*/

