/// @function scr_simulation_18_draw_gui()


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

for (var i = 0; i < ds_list_size(global.GUI_ROOM_AXES); i++)
{
    temp_list = ds_list_find_value(global.GUI_ROOM_AXES, i);
    
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
x1 = ds_list_find_value(global.GUI_ROOM_X_AXIS, 0);
y1 = ds_list_find_value(global.GUI_ROOM_X_AXIS, 1);
x2 = ds_list_find_value(global.GUI_ROOM_X_AXIS, 2);
y2 = ds_list_find_value(global.GUI_ROOM_X_AXIS, 3);
draw_line(x1, y1, x2, y2);

// draw the y axis at zero
x1 = ds_list_find_value(global.GUI_ROOM_Y_AXIS, 0);
y1 = ds_list_find_value(global.GUI_ROOM_Y_AXIS, 1);
x2 = ds_list_find_value(global.GUI_ROOM_Y_AXIS, 2);
y2 = ds_list_find_value(global.GUI_ROOM_Y_AXIS, 3);
draw_line(x1, y1, x2, y2);


/**
 * Draw Bounding Box Rays
 *
 */

var temp_list;
var x1, y1, x2, y2;
var color;

draw_set_alpha(0.5);

// iterate through all the points around the bounding box
for (var points_idx = 0; points_idx < ds_list_size(global.GUI_BBOX_POINTS); points_idx++)
{
    // get the points around the bounding box
    temp_list = ds_list_find_value(global.GUI_BBOX_POINTS, points_idx);
    
    // get the starting point
    x1 = ds_list_find_value(temp_list, 0);
    y1 = ds_list_find_value(temp_list, 1);
    x2 = ds_list_find_value(temp_list, 2);
    y2 = ds_list_find_value(temp_list, 3);
    
    color = ds_list_find_value(temp_list, 4);
    draw_set_colour(color);
    
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

for (var i = 0; i < ds_list_size(global.GUI_AXIS_POINTS); i++)
{
    temp_list = ds_list_find_value(global.GUI_AXIS_POINTS, i);
    
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
txt += simulation_name + "\n";
txt += "p1: (" + string(inst_x) + ", " + string(inst_y) + ")" + "\n";
txt += "p2: (" + string(inst_x + new_move_h) + ", " + string(inst_y + new_move_v) + ")" + "\n";
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
if (global.DRAW_CELL_INDEX >= 0 && global.DRAW_CELL_INDEX < ds_list_size(global.GUI_AXIS_POINTS))
{
    temp_list = ds_list_find_value(global.GUI_AXIS_POINTS, global.DRAW_CELL_INDEX);
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
draw_set_colour(global.COLLISION_HV_COLOR);
txt = "h/v collision";
draw_text(txt_x, txt_y, txt);
txt_y -= string_height(txt) + 5;

// display horizontal collision color
draw_set_colour(global.COLLISION_V_COLOR);
txt = "v collision";
draw_text(txt_x, txt_y, txt);
txt_y -= string_height(txt) + 5;

// display horizontal collision color
draw_set_colour(global.COLLISION_H_COLOR);
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

