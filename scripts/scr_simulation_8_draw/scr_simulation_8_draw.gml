/// @function scr_simulation_8_draw()


/**
 * Draw Sprite at Starting Position
 *
 */

draw_sprite(sprite_index, 0, sim_x, sim_y);
draw_sprite_ext(sprite_index, 0, (sim_x + new_move_h), (sim_y + new_move_v), 1, 1, 0, c_red, 0.3);


/**
 * Draw Collision Cells
 *
 */

for (var i = 0; i < ds_list_size(global.DRAW_CELLS); i++)
{
    var temp_list = ds_list_find_value(global.DRAW_CELLS, i);
    var x1 = ds_list_find_value(temp_list, 0);
    var y1 = ds_list_find_value(temp_list, 1);
    var color = ds_list_find_value(temp_list, 2);
    draw_sprite_ext(spr_point, 0, x1, y1, global.TILE_SIZE, global.TILE_SIZE, 0, color, 0.2);
}

if (global.DRAW_CELL_INDEX >= 0 && global.DRAW_CELL_INDEX < ds_list_size(global.DRAW_CELLS))
{
    var temp_list = ds_list_find_value(global.DRAW_CELLS, global.DRAW_CELL_INDEX);
    var x1 = ds_list_find_value(temp_list, 0);
    var y1 = ds_list_find_value(temp_list, 1);
    var color = ds_list_find_value(temp_list, 2);
    draw_sprite_ext(spr_point, 0, x1, y1, global.TILE_SIZE, global.TILE_SIZE, 0, color, 0.5);
}

