$fn = 32;

// Parameters
diameter = 55;          // Hole diameter
overhang_angle = 45;    // Between 0 and 90 degrees, non-inclusive
slot_width = 2;         // Must be less than depth
depth = 6;              // Must be greater than slot width
thickness = 3;

// Rectangular base dimensions
base_length = diameter + 2 * thickness;
base_height = diameter / 2 + 2 * thickness;

// Outer cylinder dimensions
outer_cylinder_diameter = diameter + 2 * thickness;

// Triangular prism
module triangular_prism (radius, angle, length) {
    triangle_x = cos(90-angle) * radius;
    triangle_bottom_y = sin(90-angle) * radius;
    triangle_top_y = tan(angle) * triangle_x + triangle_bottom_y;
    triangle_points = [
        [triangle_x, triangle_bottom_y],
        [-triangle_x, triangle_bottom_y],
        [0, triangle_top_y]
    ];
    linear_extrude(length)
        polygon(triangle_points);
}

difference() {
    union() {

        // Base
        color("lightblue")
            translate([0, 0, base_height / 2])
                cube([base_length, depth, base_height], center=true);

        // Outer cylinder
        color("lightgreen")
            translate([0, 0, base_height])
                rotate([90, 0, 0])
                    cylinder(h=depth, d=outer_cylinder_diameter, center=true);

        // Outer trianular prism
        color("lightpink")
            translate([0, depth/2, base_height])
                rotate([90,0,0])
                triangular_prism(diameter/2 + thickness, overhang_angle, depth);

    }

    union() {

        // Slot
        color("darkgreen")
            translate([0, 0, base_height/2+diameter/2+thickness])
                cube([base_length+1, slot_width, base_height+diameter], center=true);

        // Inner cylinder
        color("darkblue")
            translate([0, 0, base_height])
                rotate([90, 0, 0])
                    cylinder(h=depth+1, d=diameter, center=true);

        // Inner trianular prism
        color("lightcoral")
            translate([0, depth/2+1, base_height])
                rotate([90,0,0])
                triangular_prism(diameter/2, overhang_angle, depth+2);

    }
}