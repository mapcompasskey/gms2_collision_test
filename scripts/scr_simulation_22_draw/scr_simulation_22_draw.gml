/// @function scr_simulation_22_draw()


/**
 * Draw Sprite at Starting Position
 *
 */

draw_sprite(sprite_index, 0, inst_x, inst_y);
//draw_sprite_ext(sprite_index, 0, (inst_x + new_move_h), (inst_y + new_move_v), 1, 1, 0, c_red, 0.8);
draw_sprite_ext(sprite_index, 0, inst_x2, inst_y2, 1, 1, 0, c_purple, 1);


/**
 * Draw the Horizontal and Vertical Collision Cells
 *
 */

// if there are cell to draw
// *any cell that is passed through by a ray is added to the list
if (ds_list_size(global.DRAW_CELLS) > 0)
{
    var temp_list, x1, y1, color;
    
    // if individual cells are being viewed
    if (global.DRAW_CELL_INDEX >= 0 && global.DRAW_CELL_INDEX < ds_list_size(global.DRAW_CELLS))
    {
        temp_list = ds_list_find_value(global.DRAW_CELLS, global.DRAW_CELL_INDEX);
        x1 = ds_list_find_value(temp_list, 0);
        y1 = ds_list_find_value(temp_list, 1);
        color = ds_list_find_value(temp_list, 2);
        if (color != noone)
        {
            draw_sprite_ext(spr_point, 0, x1 + 1, y1 + 1, global.TILE_SIZE - 2, global.TILE_SIZE - 2, 0, color, 0.25);
        }
    }
    // else, display all the cells
    else
    {
        for (var i = 0; i < ds_list_size(global.DRAW_CELLS); i++)
        {
            temp_list = ds_list_find_value(global.DRAW_CELLS, i);
            x1 = ds_list_find_value(temp_list, 0);
            y1 = ds_list_find_value(temp_list, 1);
            color = ds_list_find_value(temp_list, 2);
            if (color != noone)
            {
                draw_sprite_ext(spr_point, 0, x1 + 1, y1 + 1, global.TILE_SIZE - 2, global.TILE_SIZE - 2, 0, color, 0.25);
            }
        }
    }
}
