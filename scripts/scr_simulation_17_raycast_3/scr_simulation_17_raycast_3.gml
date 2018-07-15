/// @function scr_simulation_17_raycast_3();


/**
 * Tile Based Collision Test
 *
 * Cast a ray from the top left corner of an object checking every horizontal and veritcal intersection for collision with a tile.
 * At each horizontal intersection, check every tile the height of the bounding box (of the instance) would pass through.
 * At each vertical intersection, check every tile the width of the bounding box (of the instance) would pass through.
 */

var _capture_step_points = false;
var _capture_step_tiles_h = false;
var _capture_step_tiles_v = false;
var _capture_step_special_tiles = true;
var _capture_collision_tiles = true;

// if there is no movement
if (raycast_new_move_h == 0 && raycast_new_move_v == 0)
{
    exit;
}

// starting position (always the top left corner of the bounding box)
var _start_x = raycast_x + sprite_bbox_left;
var _start_y = raycast_y + sprite_bbox_top;

// movement values
var _new_move_h = raycast_new_move_h;
var _new_move_v = raycast_new_move_v;

var _redirect_move_h = 0;
var _redirect_move_v = 0;

// collision states
var _collision_h = false;
var _collision_v = false;
var _collision_slope = false;

// tilemap layer and tile size
var _collision_tilemap = collision_tilemap;
var _tile_size = tile_size;


/**
 * Find the X and Y Offsets
 *
 * Apply offsets when the ray should be shifted to the right side or bottom side of the bounding box.
 * Always add one since the width and height of GML bounding boxes are off by one pixel.
 */

// get the size of the bounding box and offsets
var _height = (bbox_height + 1);
var _width = (bbox_width + 1);
var _offset_x = (raycast_new_move_h > 0 ? _width : 0);
var _offset_y = (raycast_new_move_v > 0 ? _height : 0);

// horizontal rays
if (raycast_new_move_h != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_x), _start_y, (_start_x + _offset_x + raycast_new_move_h), (_start_y + raycast_new_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_x), (_start_y + _height), (_start_x + _offset_x + raycast_new_move_h), (_start_y + _height + raycast_new_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// vertical rays
if (raycast_new_move_v != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _start_x, (_start_y + _offset_y), (_start_x + raycast_new_move_h), (_start_y + _offset_y + raycast_new_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _width), (_start_y + _offset_y), (_start_x + _width + raycast_new_move_h), (_start_y + _offset_y + raycast_new_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}


/**
 * Prepare Values
 *
 */

var _cell_x, _cell_y;
var _cell_max_x, _cell_max_y;
var _step_cell_x, _step_cell_y;
var _size_delta, _size_target;
var _remainder_x, _remainder_y;

// the test that can be performed
var _test_h = (raycast_new_move_h == 0 ? false : true);
var _test_v = (raycast_new_move_v == 0 ? false : true);

// the slope of the line
// *using the term "gradient" since "slope" can also refer to a type of tile
var _gradient = 0;
if (raycast_new_move_h != 0 && raycast_new_move_v != 0)
{
    _gradient = (raycast_new_move_v / raycast_new_move_h);
}

// the distances traveled along the ray
var _ray_delta_h = 0;
var _ray_delta_v = 0;

// the maximum distance of the ray
var _ray_target = point_distance(0, 0, raycast_new_move_h, raycast_new_move_v);

// the distance to the closest collision points
var _ray_target_h = _ray_target;
var _ray_target_v = _ray_target;

// the point to check horizontally
var _step_h_x = (_start_x + _offset_x);
var _step_h_y = _start_y;

// the point to check vertically
var _step_v_x = _start_x;
var _step_v_y = (_start_y + _offset_y);

// tile offsets
var _tile_offset_x = (raycast_new_move_h > 0 ? 1 : 0);
var _tile_offset_y = (raycast_new_move_v > 0 ? 1 : 0);

// tile values
var _tile_at_point;
var _tile_solid = global.TILE_SOLID;

var _tile_h_one_way = (raycast_new_move_h > 0 ? global.TILE_SOLID_EAST : global.TILE_SOLID_WEST);
var _tile_v_one_way = (raycast_new_move_v > 0 ? global.TILE_SOLID_SOUTH : global.TILE_SOLID_NORTH);


/**
 * Move Along the Ray Testing for Collisions
 *
 * Move towards each horizontal and veritcal intersection until a tile is found.
 * At each intersection, test the width or height of the bounding box, checking for tiles along the opposite intersection.
 */
scr_output("---");
scr_output("---");
// while test can be performed and no collisions have occurred
while ((_test_h || _test_v) && ! _collision_h && ! _collision_v)
{
    // if the horizontal collision test can be performed
    // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
    if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
    {
        // find the cell the first point occupies
        // *the first point is always the top of the bounding box
        _cell_x = floor(_step_h_x / _tile_size);
        _cell_y = floor(_step_h_y / _tile_size);
        
        // find how far from an interseciton the points are
        // *if the remainder is 0, then they are directly on an intersection
        _remainder_x = _step_h_x mod _tile_size;
        _remainder_y = _step_h_y mod _tile_size;
        
        // if the horizontal movement is negative and the point is on a horizontal intersection
        // *the instance is moving left, shift the tile's x position left by one
        if (raycast_new_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (raycast_new_move_v < 0 && _remainder_y == 0)
        {
            _cell_y -= 1; 
        }
        
        if (_capture_step_points)
        {
            var _list = ds_list_create();
            ds_list_add(_list, _step_h_x, _step_h_y, global.COLLISION_HV_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        }
        
        // find the cell the last point occupies
        // *the last point is always the bottom of the bounding box
        var _cell_max_y = floor((_step_h_y + _height) / _tile_size);
        
        // if the last point is on a vertical intersection
        if ((_step_h_y + _height) mod _tile_size == 0)
        {
            // if the vertical movement is less than or equal to 0
            // *the instance is either not moving vertically or is moving up, shift the cell of the last point up by one
            if (_new_move_v <= 0)
            {
                _cell_max_y -= 1;
            }
        }
        
        scr_output("---");
        scr_output("_remainder_x", _remainder_x, "_remainder_y", _remainder_y);
        scr_output("_cell_y", _cell_y, "_cell_max_y", _cell_max_y);
        
        // for every horizontal intersection the ray is cast through, check every vertical tile between the top and bottom of the bounding box
        for (_step_cell_y = _cell_y; _step_cell_y <= _cell_max_y; _step_cell_y++)
        {
            scr_output("_step_cell_y", _step_cell_y);
            
            if (_capture_step_tiles_h)
            {
                // capture the tile
                var _list = ds_list_create();
                ds_list_add(_list, (_cell_x * _tile_size), (_step_cell_y * _tile_size), global.COLLISION_H_COLOR);
                ds_list_add(global.DRAW_CELLS, _list);
                ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            }
            
            // get the tile at this position
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _step_cell_y) & tile_index_mask;
            
            // if this tile is empty space
            if (_tile_at_point == 0)
            {
                continue;
            }
            
            /** /
            // if moving up and this is the first collision step
            // or if moving down and this is the last collision step
            //if ((_new_move_v < 0 && _step_cell_y == _cell_y) || (_new_move_v > 0 && _step_cell_y == (_cell_max_y - 1)))
            if ((_new_move_v < 0 && _step_cell_y == _cell_y) || (_new_move_v > 0 && _step_cell_y == _cell_max_y))
            {
                // if colliding with the exact corner of a tile
                // *because horizontal collision is checked first, this would result in a horizontal collision
                // *but if the path above (or below) the tile is clear horizontally, then it should be resolved as a vertical collision and continue horizontally
                if (_tile_at_point == _tile_solid && _remainder_x == 0 && _remainder_y == 0 && _new_move_v != 0)
                {
                    if (_capture_step_special_tiles)
                    {
                        var _list = ds_list_create();
                        ds_list_add(_list, (_cell_x * _tile_size), ((_step_cell_y + (_new_move_v > 0 ? -1 : 1)) * _tile_size), global.COLLISION_HV_COLOR);
                        ds_list_add(global.DRAW_CELLS, _list);
                        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                    }
                    
                    // shift the current tile one above or below depending on the vertical movement
                    _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _step_cell_y + (_new_move_v > 0 ? -1 : 1)) & tile_index_mask;
                    
                    // if this tile is empty space
                    if (_tile_at_point == 0)
                    {
                        continue;
                    }
                    
                }
            }
            /**/
            
            /*
            if (_tile_at_point == _tile_solid)
            {
                if (_new_move_v < 0 && _step_cell_y == _cell_y && _remainder_x == 0 && _remainder_y == 0)
                {
                    if (_capture_step_special_tiles)
                    {
                        var _list = ds_list_create();
                        ds_list_add(_list, (_cell_x * _tile_size), ((_step_cell_y + 1) * _tile_size), global.COLLISION_HV_COLOR);
                        ds_list_add(global.DRAW_CELLS, _list);
                        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                    }
                    
                    // shift the current tile one above or below depending on the vertical movement
                    var _tile_at_point_2 = tilemap_get(_collision_tilemap, _cell_x, (_step_cell_y + 1)) & tile_index_mask;
                    
                    // if this tile is empty space
                    if (_tile_at_point_2 == 0)
                    {
                        continue;
                    }
                    
                }
                
                if (_new_move_v > 0 && _step_cell_y == _cell_max_y && _remainder_x == 0 && (_remainder_y + _height) == _tile_size)
                {
                    if (_capture_step_special_tiles)
                    {
                        var _list = ds_list_create();
                        ds_list_add(_list, (_cell_x * _tile_size), ((_step_cell_y - 1) * _tile_size), global.COLLISION_HV_COLOR);
                        ds_list_add(global.DRAW_CELLS, _list);
                        ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                    }
                    
                    // shift the current tile one above or below depending on the vertical movement
                    var _tile_at_point_2 = tilemap_get(_collision_tilemap, _cell_x, (_step_cell_y - 1)) & tile_index_mask;
                    
                    // if this tile is empty space
                    if (_tile_at_point_2 == 0)
                    {
                        continue;
                    }
                    
                }
            }
            */
            
            // if colliding with a solid tile or one that is solid from this side
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_h_one_way)
            {
                // if not the first horizontal test, or if the point is on a horizontal intersection
                if (_ray_delta_h != 0 || _remainder_x == 0)
                {
                    // update the horizontal target distance
                    _ray_target_h = point_distance((_start_x + _offset_x), _start_y, _step_h_x, _step_h_y);
                    if (_ray_target_h <= _ray_target_v)
                    {
                        // update collision states
                        _test_h = false;
                        _collision_h = true;
                        
                        // update the movement values
                        _new_move_h = _step_h_x - (_start_x + _offset_x);
                        _new_move_v = _step_h_y - _start_y;
                        
                        // update the redirection values for another test
                        _redirect_move_h = 0;
                        _redirect_move_v = (raycast_new_move_v - _new_move_v);
                        
                        if (_capture_collision_tiles)
                        {
                            // capture the tile
                            var _list = ds_list_create();
                            ds_list_add(_list, (_cell_x * _tile_size), (_step_cell_y * _tile_size), global.COLLISION_H_COLOR);
                            ds_list_add(global.DRAW_CELLS, _list);
                            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                        }
                        
                        break;
                    }
                    
                }
            }
            
            /*
            // if colliding with another type of tile
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_h_one_way)
            {
                // prepare the slope collision test
                raycast_slope_x = _step_h_x;
                raycast_slope_y = _step_h_y;
                
                // if colliding with a sloped tile, and a point on the slope is found
                if (script_execute(script_slope_collision, _tile_at_point, _cell_x, _step_cell_y, _gradient, _ray_target_h))
                {
                    // update collision states
                    _collision_slope = true;
                    _collision_h = true;
                    _test_h = false;
                    
                    // update the movement values
                    _new_move_h = raycast_slope_x - _start_x;
                    _new_move_v = raycast_slope_y - _start_y;
                    
                    // update the movement values for another test
                    _redirect_move_h = raycast_slope_move_h;
                    _redirect_move_v = raycast_slope_move_v;
                    
                    // update the collision target distance
                    _ray_target_h = point_distance(0, 0, _new_move_h, _new_move_v);
                    
                    break;
                }
                
            }
            */
            
        }
        
        // if no collision occurred during this step
        if (_collision_h == false)
        {
            // move to the next horizontal intersection
            _step_h_x = round((_cell_x + _tile_offset_x) * _tile_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_h_y = (_gradient * (_step_h_x - (_start_x + _offset_x))) + _start_y;
                
                // if the y position is off a vertical intersection by a tiny amount, round towards the intersection
                // *GameMaker returns inconsistent solutions when calculating the sin/cos of an angle
                var _remainder_h_y = (_step_h_y mod _tile_size);
                if (_remainder_h_y < 0.0001) _step_h_y = floor(_step_h_y);
                if (_tile_size - _remainder_h_y < 0.0001) _step_h_y = ceil(_step_h_y);
            }
            
            // update the distance to the next vertical intersection
            _ray_delta_h = point_distance((_start_x + _offset_x), _start_y, _step_h_x, _step_h_y);
            
            // continue collision until the target distance is reached
            _test_h = (_ray_delta_h < _ray_target);
        }
        
    }
    
    // else, if vertical collision test can be performed
    // (and either can't test horizontal collision or the vertical test is closer than the horizontal test)
    else if  (_test_v && ( ! _test_h || _ray_delta_v <= _ray_delta_h))
    {
        // find the cell the first point occupies
        // *the first point is always the left side of the bounding box
        _cell_x = floor(_step_v_x / _tile_size);
        _cell_y = floor(_step_v_y / _tile_size);
        
        // find how far from an interseciton the points are
        // *if the remainder is 0, then they are directly on an intersection
        _remainder_x = _step_v_x mod _tile_size;
        _remainder_y = _step_v_y mod _tile_size;
        
        // if the horizontal movement is negative and the point is on a horizontal intersection
        // *the instance is moving left, shift the tile's x position left by one
        if (raycast_new_move_h < 0 && _remainder_x == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the point is on a vertical intersection
        // *the instance is moving up, shift the tile's y position up by one
        if (raycast_new_move_v < 0 && _remainder_y == 0)
        {
            _cell_y -= 1; 
        }

        if (_capture_step_points)
        {
            var _list = ds_list_create();
            ds_list_add(_list, _step_v_x, _step_v_y, global.COLLISION_HV_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
            
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_V_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        }
        
        // find the cell the last point occupies
        // *the last point is always the right side of the bounding box
        var _cell_max_x = floor((_step_v_x + _width) / _tile_size);
        
        // if the last point is on a horizontal intersection
        if ((_step_v_x + _width) mod _tile_size == 0)
        {
            // if the horizontal movement is less than or equal to 0
            // *the instance is either not moving horizontally or is moving to the left, shift the cell of the last point left by one
            if (_new_move_h <= 0)
            {
                _cell_max_x -= 1;
            }
        }
        
        // for every vertical intersection the ray is cast through, check every horizontal tile between the left and right sides of the bounding box
        for (_step_cell_x = _cell_x; _step_cell_x <= _cell_max_x; _step_cell_x++)
        {
            if (_capture_step_tiles_v)
            {
                // capture the tile
                var _list = ds_list_create();
                ds_list_add(_list, (_step_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_V_COLOR);
                ds_list_add(global.DRAW_CELLS, _list);
                ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
            }
            
            // get the tile at this position
            _tile_at_point = tilemap_get(_collision_tilemap, _step_cell_x, _cell_y) & tile_index_mask;
            
            // if this tile is empty space
            if (_tile_at_point == 0)
            {
                continue;
            }
            
            // if colliding with a solid tile or one that is solid from this side
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_v_one_way)
            {
                // if not the first vertical test, or if the point is on a vertical intersection
                if (_ray_delta_v != 0 || _remainder_y == 0)
                {
                    // update the vertical target distance
                    _ray_target_v = point_distance(_start_x, (_start_y + _offset_y), _step_v_x, _step_v_y);
                    if (_ray_target_v <= _ray_target_h)
                    {
                        // update collision states
                        _test_v = false;
                        _collision_v = true;
                        
                        // update the movement values
                        _new_move_h = _step_v_x - _start_x;
                        _new_move_v = _step_v_y - (_start_y + _offset_y);
                        
                        // update the redirection values for another test
                        _redirect_move_h = (raycast_new_move_h - _new_move_h);
                        _redirect_move_v = 0;
                        
                        if (_capture_collision_tiles)
                        {
                            // capture the tile
                            var _list = ds_list_create();
                            ds_list_add(_list, (_step_cell_x * _tile_size), (_cell_y * _tile_size), global.COLLISION_V_COLOR);
                            ds_list_add(global.DRAW_CELLS, _list);
                            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
                        }
                    
                        break;
                    }
                    
                }
            }
            
            /*
            // if colliding with another type of tile
            if (_tile_at_point != _tile_solid && _tile_at_point != _tile_v_one_way)
            {
                // prepare the slope collision test
                raycast_slope_x = _step_v_x;
                raycast_slope_y = _step_v_y;
                
                // if a sloped tile, and a point on the slope was found
                if (script_execute(script_slope_collision, _tile_at_point, _step_cell_x, _cell_y, _gradient, _ray_target_v))
                {
                    // update collision states
                    _collision_slope = true;
                    _collision_v = true;
                    _test_v = false;
                    
                    // update the movement values
                    _new_move_h = raycast_slope_x - _start_x;
                    _new_move_v = raycast_slope_y - _start_y;
                    
                    // update the movement values for another test
                    _redirect_move_h = raycast_slope_move_h;
                    _redirect_move_v = raycast_slope_move_v;
                    
                    // update the collision target distance
                    _ray_target_v = point_distance(0, 0, _new_move_h, _new_move_v);
                    
                    break;
                }
                
            }
            */
            
        }
        
        // if no collision occurred during this step
        if (_collision_v == false)
        {
            // move to the next vertical intersection
            _step_v_y = round((_cell_y + _tile_offset_y) * _tile_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_v_x = ((_step_v_y - (_start_y + _offset_y)) / _gradient) + _start_x;
                
                // if the x position is off a horizontal intersection by a tiny amount, round towards the intersection
                // *GameMaker returns inconsistent solutions when calculating the sin/cos of an angle
                var _remainder_v_x = (_step_v_x mod _tile_size);
                if (_remainder_v_x < 0.0001) _step_v_x = floor(_step_v_x);
                if (_tile_size - _remainder_v_x < 0.0001) _step_v_x = ceil(_step_v_x);
            }
            
            // update the distance to the next vertical intersection
            _ray_delta_v = point_distance(_start_x, (_start_y + _offset_y), _step_v_x, _step_v_y);
            
            // continue collision until the target distance is reached
            _test_v = (_ray_delta_v < _ray_target);
        }
        
    }
    
    // else, unexpected condition
    else
    {
        break;
    }
    
}


/**
 * Update Values
 *
 */

// update movement values
raycast_new_move_h = _new_move_h;
raycast_new_move_v = _new_move_v;
raycast_redirect_move_h = _redirect_move_h;
raycast_redirect_move_v = _redirect_move_v;

//raycast_move_distance_target = _ray_target;
//var _ray_delta_h = raycast_move_distance_delta;
//var _ray_delta_v = raycast_move_distance_delta;

// update collision states
raycast_collision_h = _collision_h;
raycast_collision_v = _collision_v;
raycast_collision_slope = _collision_slope;

