/// @function scr_simulation_9_entity_step_1()


/**
 * Test Movement Collision Against Tilemap
 *
 */

collision_h = false;
collision_v = false;

new_move_h = move_h;
new_move_v = move_v;

if (collision_tilemap == noone)
{
    exit;
}

if (bbox_width && bbox_height)
{
    var steps = 0;
    var step_size = 0;
    var steps_2 = 0;
    var step_size_2 = 0;
    
    var offset_x = 0;
    var offset_y = 0;
    var target_x = 0;
    var target_y = 0;
    var result_x = 0;
    var result_y = 0;
    
    var collision = false;
    var tile_1 = 1;
    var tile_2 = 1;
    var tile_at_point = 0;
    
    // vertical collision test
    if (move_v != 0)
    {
        // if moving more than the height of the sprite or the size of a tile,
        // check the path, using the smallest value, for any collisions
        steps = 1;
        if (abs(move_v) > min(bbox_height, cell_size))
        {
            steps = ceil(abs(move_v) / min(bbox_height, cell_size));
        }
        step_size = (move_v / steps);
        
        // if the sprite is wider than a tile,
        // check in increments along its width
        steps_2 = 1;
        if (bbox_width > cell_size)
        {
            steps_2 = ceil(bbox_width / cell_size);
        }
        step_size_2 = (bbox_width / steps_2);
        
        for (var i = 1; i <= steps; i++)
        {
            collision = false;
            tile_1 = 1;
            tile_2 = 1;
            
            // if moving up
            if (move_v < 0)
            {
                offset_y = sprite_bbox_top;
            }
            // else, if moving down
            else
            {
                offset_y = sprite_bbox_bottom;
            }
            
            // get top or bottom position
            target_y = round(y + offset_y + (step_size * i));
            
            // check left edge and mid points
            if ( ! collision)
            {
                for (var j = 0; j < steps_2; j++)
                {
                    target_x = round(x + sprite_bbox_left + (step_size_2 * j));
                    tile_at_point = tilemap_get_at_pixel(collision_tilemap, target_x, target_x) & tile_index_mask;
                    if (tile_at_point == tile_1 || tile_at_point == tile_2)
                    {
                        collision = true;
                        j = steps_2;
                    }
                }
            }
            
            // check right edge
            if ( ! collision)
            {
                target_x = round(x + sprite_bbox_right);
                tile_at_point = tilemap_get_at_pixel(collision_tilemap, target_x, target_x) & tile_index_mask;
                if (tile_at_point == tile_1 || tile_at_point == tile_2)
                {
                    collision = true;
                }
            }
            
            if (collision)
            {
                new_move_v = result_y - offset_y - y;
                collision_v = true;
                    
                break; // end for()
            }
        
        }
    
    }
    
    // horizontal collision test
    if (move_h != 0)
    {
        // if moving more than the width of the sprite or the size of a tile,
        // check the path, using the smallest value, for any collisions
        steps = 1;
        if (abs(move_h) > min(bbox_width, cell_size))
        {
            steps = ceil(abs(move_h) / min(bbox_width, cell_size));
        }
        step_size = (move_h / steps);
        
        // if the sprite is taller than a tile,
        // check in increments along its height
        steps_2 = 1;
        if (bbox_height > cell_size)
        {
            steps_2 = ceil(bbox_height / cell_size);
        }
        step_size_2 = (bbox_height / steps_2);
        
        for (var i = 1; i <= steps; i++)
        {
            collision = false;
            tile_1 = 1;
            tile_2 = 1;
            
            // if moving right
            if (move_h > 0)
            {
                offset_x = sprite_bbox_right;
            }
            // else, if moving left
            else
            {
                offset_x = sprite_bbox_left;
            }
            
            // get left or right position
            target_x = round(x + offset_x + (step_size * i));
            
            // check bottom edge and mid points
            if ( ! collision)
            {
                for (var j = 0; j < steps_2; j++)
                {
                    target_y = round(y + sprite_bbox_bottom + new_move_v - (step_size_2 * j));
                    tile_at_point = tilemap_get_at_pixel(collision_tilemap, target_x, target_x) & tile_index_mask;
                    if (tile_at_point == tile_1 || tile_at_point == tile_2)
                    {
                        collision = true;
                        j = steps_2;
                    }
                }
            }
            
            // check top edge
            if ( ! collision)
            {
                target_y = round(y + sprite_bbox_top + new_move_v);
                tile_at_point = tilemap_get_at_pixel(collision_tilemap, target_x, target_x) & tile_index_mask;
                if (tile_at_point == tile_1 || tile_at_point == tile_2)
                {
                    collision = true;
                }
            }
            
            if (collision)
            {
                new_move_h = result_x - offset_x - x;
                collision_h = true;
                    
                break; // end for()
            }
        
        }
    
    }
}

