/// @function scr_simulation_12_raycast();


/**
 * Tile Based Collision Test
 *
 * Cast a ray from a point and check each horizontal and veritcal intersection for collision with a tile.
 * At each intersection, move away from the point, the length of the bounding box, checking for collisions with adjacent tiles.
 */

// the starting position
var _start_x = raycast_x;
var _start_y = raycast_y;

// movement values
var _move_h = raycast_move_h;
var _move_v = raycast_move_v;

// the collision states
var _collision_h = false;
var _collision_v = false;

// the tilemap layer and tile size
var _collision_tilemap = collision_tilemap;
var _cell_size = global.TILE_SIZE;

// if there is no movement
if (raycast_move_h == 0 && raycast_move_v == 0)
{
    exit;
}


/**
 * Find the Corner to Raycast From
 *
 * Always cast the ray from the point that would collide first with a tile.
 * Straight horizontal test are always cast from the bottom left or bottom right of the boudning box.
 * Straight vertical test are cast from the top right or bottom right of the bounding box.
 * /

// *minimum values are only being used for displaying the rays in the GUI

var _x_min = (_start_x + sprite_bbox_left);
var _x_max = (_start_x + sprite_bbox_right + 1);
if (raycast_move_h < 0)
{
    _x_min = (_start_x + sprite_bbox_right + 1);
    _x_max = (_start_x + sprite_bbox_left);
}

var _y_min = (_start_y + sprite_bbox_top);
var _y_max = (_start_y + sprite_bbox_bottom + 1);
if (raycast_move_v < 0)
{
    _y_min = (_start_y + sprite_bbox_bottom + 1);
    _y_max = (_start_y + sprite_bbox_top);
}

_start_x = _x_max;
_start_y = _y_max;

// horizontal ray (only added as a visual marker)
if (raycast_move_h != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _x_max, _y_min, (_x_max + raycast_move_h), (_y_min + raycast_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// vertical ray (only added as a visual marker)
if (raycast_move_v != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _x_min, _y_max, (_x_min + raycast_move_h), (_y_max + raycast_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// the ray to cast
var _temp_list = ds_list_create();
ds_list_add(_temp_list, _x_max, _y_max, (_x_max + raycast_move_h), (_y_max + raycast_move_v), global.COLLISION_HV_COLOR);
ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);


/**
 * Find the Corner to Raycast From
 *
 * Always cast the ray from the point that would collide first with a tile.
 * Straight horizontal test are always cast from the bottom left or bottom right of the boudning box.
 * Straight vertical test are cast from the top right or bottom right of the bounding box.
 */

// *minimum values are only being used for displaying the rays in the GUI

/*
var _x_min = (_start_x + sprite_bbox_right + 1);
var _x_max = (_start_x + sprite_bbox_left);
if (raycast_move_h > 0)
{
    _x_min = (_start_x + sprite_bbox_left);
    _x_max = (_start_x + sprite_bbox_right + 1);    
}

var _y_min = (_start_y + sprite_bbox_bottom + 1);
var _y_max = (_start_y + sprite_bbox_top);
if (raycast_move_v > 0)
{
    _y_min = (_start_y + sprite_bbox_top);
    _y_max = (_start_y + sprite_bbox_bottom + 1);    
}

_start_x = _x_max;
_start_y = _y_max;

// horizontal ray (only added as a visual marker)
if (raycast_move_h != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _x_max, _y_min, (_x_max + raycast_move_h), (_y_min + raycast_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// vertical ray (only added as a visual marker)
if (raycast_move_v != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _x_min, _y_max, (_x_min + raycast_move_h), (_y_max + raycast_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// the ray to cast
var _temp_list = ds_list_create();
ds_list_add(_temp_list, _x_max, _y_max, (_x_max + raycast_move_h), (_y_max + raycast_move_v), global.COLLISION_HV_COLOR);
ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
*/

// set the starting position to the top left corner of the boudning box
_start_x = _start_x + sprite_bbox_left;
_start_y = _start_y + sprite_bbox_top;

// get the horizontal offset
var _offset_h_x = (raycast_move_h > 0 ? bbox_width + 1 : 0);
var _offset_h_y = (bbox_height + 1);

var _offset_v_x = (bbox_width + 1);
var _offset_v_y = (raycast_move_v > 0 ? bbox_height + 1 : 0);

// horizontal rays
if (raycast_move_h != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_h_x), _start_y, (_start_x + _offset_h_x + raycast_move_h), (_start_y + raycast_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_h_x), (_start_y + _offset_h_y), (_start_x + _offset_h_x + raycast_move_h), (_start_y + _offset_h_y + raycast_move_v), global.COLLISION_H_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}

// vertical rays
if (raycast_move_v != 0)
{
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, _start_x, (_start_y + _offset_v_y), (_start_x + raycast_move_h), (_start_y + _offset_v_y + raycast_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
    
    var _temp_list = ds_list_create();
    ds_list_add(_temp_list, (_start_x + _offset_v_x), (_start_y + _offset_v_y), (_start_x + _offset_v_x + raycast_move_h), (_start_y + _offset_v_y + raycast_move_v), global.COLLISION_V_COLOR);
    ds_list_add(global.GUI_BBOX_POINTS, _temp_list);
    ds_list_mark_as_list(global.GUI_BBOX_POINTS, ds_list_size(global.GUI_BBOX_POINTS) - 1);
}


/**
 * Prepare Values
 *
 */

var _cell_x, _cell_y;
var _size_delta, _size_target;

// the test that can be performed
var _test_h = (raycast_move_h == 0 ? false : true);
var _test_v = (raycast_move_v == 0 ? false : true);

// the slope of the line
// *using the term "gradient" since "slope" can also refer to a type of tile
var _gradient = 0;
if (raycast_move_h != 0 && raycast_move_v != 0)
{
    _gradient = (raycast_move_v / raycast_move_h);
}

// the distances traveled along the ray
var _ray_delta_h = 0;
var _ray_delta_v = 0;

// the maximum distance of the ray
var _ray_target = point_distance(0, 0, raycast_move_h, raycast_move_v);

// the distances to the collision points
var _ray_target_h = _ray_target;
var _ray_target_v = _ray_target;

// the point to check horizontally
var _step_h_x = (_start_x + _offset_h_x);
var _step_h_y = _start_y;

// the point to check vertically
var _step_v_x = _start_x;
var _step_v_y = (_start_y + _offset_v_y);

// cell offsets
var _cell_offset_x = (raycast_move_h > 0 ? 1 : 0);
var _cell_offset_y = (raycast_move_v > 0 ? 1 : 0);

// tile values
var _tile_at_point;
var _tile_h_one_way = (raycast_move_h > 0 ? global.TILE_SOLID_EAST : global.TILE_SOLID_WEST);
var _tile_h_slope_45_1 = (raycast_move_h > 0 ? global.TILE_SOLID_45_SE : global.TILE_SOLID_45_SW);
var _tile_h_slope_45_2 = (raycast_move_h > 0 ? global.TILE_SOLID_45_NE : global.TILE_SOLID_45_NW);
var _tile_v_one_way = (raycast_move_v > 0 ? global.TILE_SOLID_SOUTH : global.TILE_SOLID_NORTH);
var _tile_v_slope_45_1 = (raycast_move_v > 0 ? global.TILE_SOLID_45_SE : global.TILE_SOLID_45_NE);
var _tile_v_slope_45_2 = (raycast_move_v > 0 ? global.TILE_SOLID_45_SW : global.TILE_SOLID_45_NW);


/**
 * Move Along the Ray Testing for Collisions
 *
 * Move towards each horizontal and veritcal intersection until a tile is found.
 * At each intersection, test the width or height of the bounding box, checking for tiles along the opposite intersection.
 */

// while test can be performed and no collisions have occurred
while ((_test_h || _test_v) && ! _collision_h && ! _collision_v)
{
    // if the horizontal collision test can be performed
    // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
    if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
    {
        // find the cell this point occupies
        _cell_x = floor(_step_h_x / _cell_size);
        _cell_y = floor(_step_h_y / _cell_size);
        
        // if the horizontal movement is negative and the horizontal point is on a horizontal intersection
        // *the entity is moving left, shift the cell's x position left by one
        if (raycast_move_h < 0 && _step_h_x mod _cell_size == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the vertical point is on a vertical intersection
        // *the entity is moving up, shift the cell's y position up by one
        if (raycast_move_v < 0 && _step_h_y mod _cell_size == 0)
        {
            _cell_y -= 1; 
        }
        
        if (false)
        {
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _cell_size), (_cell_y * _cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
            var _list = ds_list_create();
            ds_list_add(_list, _step_h_x, _step_h_y, global.COLLISION_HV_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        }
        
        // the maximum vertical cell to check
        var _cell_y2 = ceil((_step_h_y + _offset_h_y) / _cell_size);
        
        // if the vertical movement is positive and the point is on a vertical intersection
        // *the entity is moving down, shift the maximum vertical cell up by one to include the additional cell check
        if (raycast_move_v > 0 && _step_h_y mod _cell_size == 0)
        {
            _cell_y2 += 1;
        }
        
        // check every vertical cell the entity would pass through at this horizontal step
        for (var i = _cell_y; i < _cell_y2; i++)
        {
            // capture the cell
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _cell_size), (i * _cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        }
        
        // if no collision occurred during this step
        if (_collision_h == false)
        {
            // move to the next horizontal intersection
            _step_h_x = round((_cell_x + _cell_offset_x) * _cell_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_h_y = (_gradient * (_step_h_x - _offset_h_x - _start_x)) + _start_y;
                
                // if the y position is off a vertical intersection by a tiny amount, round towards the intersection
                // *GameMaker returns inconsistent solutions when calculating the sin/cos of an angle
                var _remainder_h_y = (_step_h_y mod _cell_size);
                if (_remainder_h_y < 0.0001) _step_h_y = floor(_step_h_y);
                if (_cell_size - _remainder_h_y < 0.0001) _step_h_y = ceil(_step_h_y);
            }
            
            // update the distance to the next vertical intersection
            _ray_delta_h = point_distance((_start_x + _offset_h_x), _start_y, _step_h_x, _step_h_y);
            
            // continue collision until the target distance is reached
            _test_h = (_ray_delta_h < _ray_target);
        }
        
    }
    
    // else, if vertical collision test can be performed
    // (and either can't test horizontal collision or the vertical test is closer than the horizontal test)
    else if  (_test_v && ( ! _test_h || _ray_delta_v <= _ray_delta_h))
    {
        // find the cell this point occupies
        _cell_x = floor(_step_v_x / _cell_size);
        _cell_y = floor(_step_v_y / _cell_size);
        
        // if the horizontal movement is negative and the horizontal point is on a horizontal intersection
        // *the entity is moving left, shift the cell's x position left by one
        if (raycast_move_h < 0 && _step_v_x mod _cell_size == 0)
        {
            _cell_x -= 1;
        }
            
        // if the vertical movement is negative and the vertical point is on a vertical intersection
        // *the entity is moving up, shift the cell's y position up by one
        if (raycast_move_v < 0 && _step_v_y mod _cell_size == 0)
        {
            _cell_y -= 1; 
        }
        
        if (false)
        {
            var _list = ds_list_create();
            ds_list_add(_list, (_cell_x * _cell_size), (_cell_y * _cell_size), global.COLLISION_H_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        
            var _list = ds_list_create();
            ds_list_add(_list, _step_v_x, _step_v_y, global.COLLISION_HV_COLOR);
            ds_list_add(global.GUI_AXIS_POINTS, _list);
            ds_list_mark_as_list(global.GUI_AXIS_POINTS, ds_list_size(global.GUI_AXIS_POINTS) - 1);
        }
        
        // the maximum horizontal cell to check
        var _cell_x2 = ceil((_step_v_x + _offset_v_x) / _cell_size);
        
        // if the horizontal movement is positive and the point is on a horizontal intersection
        // *the entity is moving right, shift the maximum horizontal cell up by one to include the additional cell check
        if (raycast_move_h > 0 && _step_v_x mod _cell_size == 0)
        {
            _cell_x2 += 1;
        }
        
        // check every vertical cell the entity would pass through at this horizontal step
        for (var i = _cell_x; i < _cell_x2; i++)
        {
            // capture the cell
            var _list = ds_list_create();
            ds_list_add(_list, (i * _cell_size), (_cell_y * _cell_size), global.COLLISION_V_COLOR);
            ds_list_add(global.DRAW_CELLS, _list);
            ds_list_mark_as_list(global.DRAW_CELLS, ds_list_size(global.DRAW_CELLS) - 1);
        }
        
        // if no collision occurred during this step
        if (_collision_h == false)
        {
            // move to the next vertical intersection
            _step_v_y = round((_cell_y + _cell_offset_y) * _cell_size);
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new x point
                _step_v_x = ((_step_v_y - _offset_v_y - _start_y) / _gradient ) + _start_x;
                
                // if the x position is off a horizontal intersection by a tiny amount, round towards the intersection
                // *GameMaker returns inconsistent solutions when calculating the sin/cos of an angle
                var _remainder_v_x = (_step_v_x mod _cell_size);
                if (_remainder_v_x < 0.0001) _step_v_x = floor(_step_v_x);
                if (_cell_size - _remainder_v_x < 0.0001) _step_v_x = ceil(_step_v_x);
            }
            
            // update the distance to the next vertical intersection
            _ray_delta_v = point_distance(_start_x, (_start_y + _offset_v_y), _step_v_x, _step_v_y);
            
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
raycast_move_h = _move_h;
raycast_move_v = _move_v;

// update collision states
raycast_collision_h = _collision_h;
raycast_collision_v = _collision_v;

