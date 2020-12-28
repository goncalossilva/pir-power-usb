include <pir-power-usb-common.scad>
use <pir-power-usb-bottom.scad>
use <pir-power-usb-top.scad>

bottom_enclosure();
rotate(a=[0, 180, 0]) translate([-width, 0, -height]) {
    top_enclosure();
}
