/// @function scr_simulation_23_draw_gui()


draw_set_font(font_arial_10pt);
draw_set_color(c_white);
draw_text(10, 30, "FPS = " + string(fps_real));
draw_text(10, 50, string(low_fps) + " - " + string(high_fps));

//with (obj_simulation_23_entity)
//{
//    draw_text(10, 70, string(velocity_x) + " - " + string(velocity_y));
//}
