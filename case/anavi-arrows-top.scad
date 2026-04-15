// ========================
// Parameters
// ========================
// PCB corner radius
corner_r = 5;    
// Wall thickness
wall_thickness = 2;  
// smooth corners
$fn = 64;              


// Case (2 mm shorter than the bottom, aka 1 mm on each side)
case_width = 83;
case_lenght = 66;
case_height = 2.5;

// Outer cylinder
outer_r = 4;
outer_h = 5;

// Inner hole
hole_r = 2.5;
hole_h = 4;

// Display size
display_size = 28;

// increase for smoother cone ($fn)
segments = 64;

// ========================
// Case Top Module
// ========================

module case_top() {
    difference() {
        
        // Translate so inner PCB pocket starts at (0,0)
        union() {
            
            translate([corner_r, corner_r, 0])
            // Outer shell (walls included)
            linear_extrude(height = case_height)
                rounded_rect(case_width,
                             case_lenght,
                             corner_r);
            
            // Rotary encoder border
            translate([9.5+9, 45+9, 0])
                cylinder(5, 9, 9, $fn = segments);

                        
            // Bottom left
            translate([1.5, 1, case_height])
                mounting_hole(true);
            
            // Bottom right
            translate([case_width-2*outer_r-1.5, 1, case_height])
                mounting_hole(false);
            
            // Top left
            translate([1.5, case_lenght-2*outer_r-2, case_height])
                mounting_hole_round();
            
            // No top right

            // Display holder bottom
            translate([case_width-1-2-display_size, case_lenght-5.5-display_size, case_height])
                cube([22, 3, 2]);
                
            // Display holder top
            translate([case_width-1-2-display_size, case_lenght-6, case_height])
                cube([7, 3, 2]);
        }
        
        // Display
        translate([case_width-2-display_size, case_lenght-4.5-display_size, 1])
            cube([display_size, display_size, 1.5]);
        translate([case_width-2-display_size, case_lenght-4.5-display_size+3, 0])
            cube([display_size, 20, 1]);
        // Cut the mounting element for the display
        translate([case_width-2-display_size, case_lenght-4.5-display_size, 1])
            cube([display_size, display_size, 3]);

                
        // Inner hollow segment of the keycaps
        // row with 3 keys
        translate([10.5, 3, 0])
            cube([62, 21, 30]);
        // row with the single key
        translate([10.5+21, 24, 0])
            cube([20, 19.5, 30]);

        // Opening for the rotary encoder
        translate([10.5+8, 46+8, 0])
            cylinder(10, 8, 8, $fn = segments);

        // Openings for the buttons
        
        // left
        translate([30.5+6, case_lenght-20.5, 0])
            cylinder(3, 1, 1, $fn = segments);
        
        // right
        translate([30.5+6+8, case_lenght-20.5, 0])
            cylinder(3, 1, 1, $fn = segments);
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
// Mounting holes
// ========================
module mounting_hole_round() {
    // Position at start
    translate([outer_r, outer_r, 0]) {
        difference() {
            // Outer cylinder
            cylinder(h = outer_h, r = outer_r, $fn = segments);
            
            // Inner hole
            translate([0, 0, outer_h-hole_h])
                cylinder(h = hole_h, r = hole_r, $fn = segments);
        }
    }
}

module mounting_hole(left = true) {
    tr = left ? 0 : -outer_r;
    // Position at start
    translate([outer_r, outer_r, 0]) {
        difference() {
            
            union() {
                // Outer cylinder
                cylinder(h = outer_h, r = outer_r, $fn = segments);
                translate([tr, -outer_r, 0])
                    cube([4, 8, outer_h]);
                translate([-outer_r, 0, 0])
                    cube([8, 4, outer_h]);
            }
            
            // Inner hole
            translate([0, 0, outer_h-hole_h])
                cylinder(h = hole_h, r = hole_r, $fn = segments);
        }
    }
}

// ========================
// Top case
// ========================

case_top();