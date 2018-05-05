/// @function scr_simulation_2_draw_gui()


// set the font
draw_set_font(font_arial_10pt);


/**
 * Draw Axes
 *
 */

var temp_list;
var x1, y1, x2, y2;

draw_set_colour(c_yellow);
draw_set_alpha(0.2);

for (var i = 0; i < ds_list_size(gui_room_axes); i++)
{
    temp_list = ds_list_find_value(gui_room_axes, i);
    
    x1 = ds_list_find_value(temp_list, 0);
    y1 = ds_list_find_value(temp_list, 1);
    
    x2 = ds_list_find_value(temp_list, 2);
    y2 = ds_list_find_value(temp_list, 3);
    
    // draw the line
    draw_line(x1, y1, x2, y2);
}


/**
 * Draw the X/Y Axis at Zero
 *
 */

var x1, y1, x2, y2;

draw_set_colour(c_yellow);
draw_set_alpha(0.5);

// draw the x axis at zero
x1 = ds_list_find_value(gui_room_x_axis, 0);
y1 = ds_list_find_value(gui_room_x_axis, 1);
x2 = ds_list_find_value(gui_room_x_axis, 2);
y2 = ds_list_find_value(gui_room_x_axis, 3);
draw_line(x1, y1, x2, y2);

// draw the y axis at zero
x1 = ds_list_find_value(gui_room_y_axis, 0);
y1 = ds_list_find_value(gui_room_y_axis, 1);
x2 = ds_list_find_value(gui_room_y_axis, 2);
y2 = ds_list_find_value(gui_room_y_axis, 3);
draw_line(x1, y1, x2, y2);


/**
 * Draw Bounding Box Paths
 *
 */

var temp_list;
var x1, y1, x2, y2;
var axis;

draw_set_alpha(0.5);

// iterate through all the points around the bounding box
for (var points_idx = 0; points_idx < ds_list_size(gui_bbox_points); points_idx++)
{
    // get the points around the bounding box
    temp_list = ds_list_find_value(gui_bbox_points, points_idx);
    
    // get the starting point
    x1 = ds_list_find_value(temp_list, 0);
    y1 = ds_list_find_value(temp_list, 1);
    
    // get the axis its testing
    axis = ds_list_find_value(temp_list, 2);
    draw_set_colour(raycast_h_color);
    if (axis == 1)
    {
        draw_set_colour(raycast_v_color);
    }
    else if (axis == 2)
    {
        draw_set_colour(raycast_hv_color);
    }
    
    // get the target point
    x2 = (x1 + move_h);
    y2 = (y1 + move_v);
    
    // scale and offset the points
    x1 = (x1 - camera_x) * view_scale;
    y1 = (y1 - camera_y) * view_scale;
    x2 = (x2 - camera_x) * view_scale;
    y2 = (y2 - camera_y) * view_scale;
    
    // draw the line
    draw_line(x1, y1, x2, y2);
}


/**
 * Draw Collision Points on the Axes
 *
 */

var temp_list;
var x0, y0, x1, y1, x2, y2;
var color;

draw_set_alpha(1.0);
draw_set_halign(fa_left);

for (var i = 0; i < ds_list_size(gui_axis_points); i++)
{
    temp_list = ds_list_find_value(gui_axis_points, i);
    
    x0 = ds_list_find_value(temp_list, 0);
    y0 = ds_list_find_value(temp_list, 1);
    
    color = ds_list_find_value(temp_list, 2);
    draw_set_colour(color);
    
    x1 = (x0 - camera_x) * view_scale;
    y1 = (y0 - camera_y) * view_scale;
    
    x2 = x1 + 5;
    y2 = y1 + 5;
    
    x1 = x1 - 5;
    y1 = y1 - 5;
    
    // draw a cross
    draw_line(x1, y1, x2, y2);
    draw_line(x1, y2, x2, y1);
    
    // if zoomed in, display the coordinates
    if (view_scale > 15)
    {
        draw_text(x1 + 5, y1, "(" + string(x0) + ", " + string(y0) + ")");
    }
    
}


/**
 * Draw Data
 *
 */

var txt = "";
txt += "Simulation 2" + "\n";
txt += "p1: (" + string(sim_x) + ", " + string(sim_y) + ")" + "\n";
txt += "p2: (" + string(sim_x + new_move_h) + ", " + string(sim_y + new_move_v) + ")" + "\n";
txt += "angle Deg: " + string_format(move_angle, 1, 5) + "\n";
txt += "angle Rad: " + string_format(move_angle_rads, 1, 5) + "\n";
txt += "h collision: " + (collision_h ? "true" : "false") + "\n";
txt += "v collision: " + (collision_v ? "true" : "false") + "\n";

var txt_x = 10;
var txt_y = 10;

// draw background
draw_set_alpha(0.5);
draw_set_colour(c_black);
draw_rectangle((txt_x - 5), (txt_y - 5), (txt_x + string_width(txt) + 10), (txt_y + string_height(txt) + 10), 0);

// draw text
draw_set_alpha(1);
draw_set_colour(c_lime);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(txt_x, txt_y, txt);


/**
 * Output Focused Cell Data
 *
 */

var x1 = 0;
var y1 = 0;
if (draw_cell_index >= 0 && draw_cell_index < ds_list_size(gui_axis_points))
{
    temp_list = ds_list_find_value(gui_axis_points, draw_cell_index);
    x1 = ds_list_find_value(temp_list, 0);
    y1 = ds_list_find_value(temp_list, 1);
}

var txt_x = 10;
var txt_y = string_height(txt) + 20;

var txt = "";
txt += "bracket keys { } to change point" + "\n";
txt += string_format(x1, 1, 20) + "\n";
txt += string_format(y1, 1, 20) + "\n";

// draw background
draw_set_alpha(0.5);
draw_set_colour(c_black);
draw_rectangle((txt_x - 5), (txt_y - 5), (txt_x + string_width(txt) + 10), (txt_y + string_height(txt) + 10), 0);

// draw text
draw_set_alpha(1);
draw_set_colour(c_lime);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(txt_x, txt_y, txt);


/**
 * Draw Collision Color Codes
 *
 */

draw_set_alpha(1);
draw_set_colour(c_lime);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

var txt = "";
var txt_x = 10;
var txt_y = (camera_height * view_scale - 10);

// display horizontal collision color
draw_set_colour(collision_hv_color);
txt = "h/v collision";
draw_text(txt_x, txt_y, txt);
txt_y -= string_height(txt) + 5;

// display horizontal collision color
draw_set_colour(collision_v_color);
txt = "v collision";
draw_text(txt_x, txt_y, txt);
txt_y -= string_height(txt) + 5;

// display horizontal collision color
draw_set_colour(collision_h_color);
txt = "h collision";
draw_text(txt_x, txt_y, txt);
txt_y -= string_height(txt) + 5;


/**
 * Draw Help Text
 *
 */

var txt = "";
txt += "(+) and (-) to zoom camera \n";
txt += "Arrow Keys to move camera \n";
txt += "WASD to move simulation \n";
txt += "(Q) and (E) to change angle \n";
txt += "hold SHIFT to move further \n";

var txt_x = (camera_width * view_scale - 10);
var txt_y = 10;

// draw background
draw_set_alpha(0.5);
draw_set_colour(c_black);
draw_rectangle((txt_x + 5), (txt_y - 5), (txt_x - string_width(txt) - 10), (txt_y + string_height(txt) + 10), 0);

// draw text
draw_set_alpha(1);
draw_set_colour(c_lime);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(txt_x, txt_y, txt);

