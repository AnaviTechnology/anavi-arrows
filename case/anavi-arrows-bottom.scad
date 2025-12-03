// ========================
// Parameters
// ========================
corner_r = 5;    // PCB corner radius

wall_thickness = 2;  // Wall thickness
$fn = 64;              // smooth corners


// Case
// PCB + 5 mm
case_width = 80 + 5;
// PCB + 5 mm
case_lenght = 63 + 5; 
// May be it too much ... let's try with 22 next time
case_height = 21;

// Outer cylinder
outer_r = 3;
outer_h = 4;

// Inner hole
hole_r = 3;
hole_h = 2;

// USB-C connector
usbc_l = 10;
usbc_h = 5;

// LED
led_r = 5;

// WS2812B LED starting Y position
// 15
led_y = 17;
// WS2812B LED distance between rows
led_d = 20;

// increase for smoother cone ($fn)
segments = 64;

// ========================
// Case Top Module
// ========================
module case_top() {

    // Translate so inner PCB pocket starts at (0,0)
    translate([corner_r, corner_r, 0]) {
        difference() {
            // Outer shell (walls included)
            linear_extrude(height = case_height)
                rounded_rect(case_width,
                             case_lenght,
                             corner_r);

            // Main hollow interior
            // Make the base thinner, just 1 mm
            translate([wall_thickness, wall_thickness, 1])
                linear_extrude(height = case_height-3)
                    rounded_rect(case_width-2*wall_thickness, case_lenght-2*wall_thickness, corner_r);
            
            // Top hollow interior
            translate([wall_thickness/2, wall_thickness/2, case_height-3])
                linear_extrude(height = 3)
                    rounded_rect(case_width-wall_thickness, case_lenght-wall_thickness, corner_r);

            // Mounting hole 1 (top left)
            translate([1.5, case_lenght-2.5-hole_r*3, 0])
                // Cone
                cylinder(wall_thickness, hole_r, hole_h, center = false, $fn = segments);
            
            // Mounting hole 2 (top right)
            translate([case_width-3.5-hole_r*3+1, case_lenght-2.5-hole_r*3, 0])
                // Cone
                cylinder(wall_thickness, hole_r, hole_h, center = false, $fn = segments);

            // Mounting hole 3 (top right)
            translate([case_width-3.5-hole_r*3+1, 1, 0])
                // Cone
                cylinder(wall_thickness, hole_r, hole_h, center = false, $fn = segments);
            
            // Mounting hole 4 (bottom left)
            translate([1.5, 1, 0])
                // Cone
                cylinder(wall_thickness, hole_r, hole_h, center = false, $fn = segments);
                
            // WS2812B LEDs
            for (row = [0:1]) {
                row_position = led_y + row*led_d;
                // LED left
                translate([19, row_position, 0])
                    cylinder(h = wall_thickness, r = led_r, $fn = segments);
                // LED right
                translate([52, row_position, 0])
                    cylinder(h = wall_thickness, r = led_r, $fn = segments);
            }
                        
        }
    }
}

// ========================
// Rounded rectangle module
// ========================
module rounded_rect(x, y, radius) {
    minkowski() {
        square([x - 2*radius, y - 2*radius], center = false);
        circle(r = radius, $fn = $fn);
    }
}

// ========================
// Mounting hole
// ========================
module mounting_hole() {
    difference() {
        // Outer cylinder
        cylinder(h = outer_h, r = outer_r, $fn = 64);
        
        // Inner hole
        translate([0, 0, outer_h-hole_h])  // hole starts at base
            cylinder(h = hole_h, r = hole_r, $fn = 64);
    }
}

module usbc() {
    rotate([90,0,0])
        linear_extrude(height = wall_thickness)
            rounded_rect(usbc_l,usbc_h,1);
}

// ========================
// Top case
// ========================

difference() {
    // Main part of the case
    case_top();  
    // USB-C connector
    // -1 mm for the z position because of the thinner base
    translate([1+38, case_lenght, 7.8])
       usbc();
}