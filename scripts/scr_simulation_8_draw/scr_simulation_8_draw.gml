/// @function scr_simulation_8_draw()


/**
 * Draw Sprite at Starting Position
 *
 */

draw_sprite(sprite_index, 0, sim_x, sim_y);
draw_sprite_ext(sprite_index, 0, (sim_x + new_move_h), (sim_y + new_move_v), 1, 1, 0, c_red, 0.5);


/**
 * Draw Collision Cells
 *
 */

if (draw_cell_index >= 0 && draw_cell_index < ds_list_size(draw_cells))
{
    var temp_list = ds_list_find_value(draw_cells, draw_cell_index);
    var x1 = ds_list_find_value(temp_list, 0);
    var y1 = ds_list_find_value(temp_list, 1);
    draw_sprite_ext(spr_point, 0, x1, y1, cell_size, cell_size, 0, c_red, 0.2);
}

