/// @function scr_simulation_11_entity_raycast_2();


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
var _cell_size = tile_size;

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
 */

var _x_max = (_start_x + sprite_bbox_right + 1);
if (raycast_move_h < 0)
{
    _x_max = (_start_x + sprite_bbox_left);
}

var _y_max = (_start_y + sprite_bbox_bottom + 1);
if (raycast_move_v < 0)
{
    _y_max = (_start_y + sprite_bbox_top);
}

_start_x = _x_max;
_start_y = _y_max;


/**
 * Prepare Values
 *
 */

var _cell_x, _cell_y;
var _size_delta, _size_target;

// tile values
var _tile_at_point;
var _tile_solid = tile_solid
var _tile_one_way = tile_solid
var _tile_slope_45_1 = tile_solid
var _tile_slope_45_2 = tile_solid

// the test that can be performed
var _test_h = (raycast_move_h == 0 ? false : true);
var _test_v = (raycast_move_v == 0 ? false : true);

// the slope of the line
// *using a different term since "slope" can also refer to a type of tile
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




// find the cell this point occupies
_cell_x = floor(_start_x / _cell_size);
_cell_y = floor(_start_y / _cell_size);

// check if the current tile being occupied is a sloped tile
_tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
//scr_output(_tile_at_point, tile_solid_45_se, tile_solid_45_sw, tile_solid_45_ne, tile_solid_45_nw);
if (_tile_at_point == tile_solid_45_se || _tile_at_point == tile_solid_45_sw || _tile_at_point == tile_solid_45_ne || _tile_at_point == tile_solid_45_nw)
{
    scr_output(_tile_at_point);
    raycast_slope_x = _start_x
    raycast_slope_y = _start_y;
    raycast_collision_slope = false;
    
    if (scr_simulation_11_entity_slope(_start_x, _start_y, _cell_x, _cell_y, _gradient, _ray_target, _tile_at_point))
    {
        // update movement values
        raycast_move_h = raycast_slope_x - _start_x;
        raycast_move_v = raycast_slope_y - _start_y;
        
        // update collision states
        raycast_collision_h = false;
        raycast_collision_v = false;
        raycast_collision_slope = true;
        
        exit;
    }
}






// the point to check horizontally
var _step_h_x = _start_x;
var _step_h_y = _start_y;

// the point to check vertically
var _step_v_x = _start_x;
var _step_v_y = _start_y;

// if testing horizontal collisions
if (_test_h)
{
    // if the point is not on a horizontal intersection
    var _remainder_x = _step_h_x mod _cell_size;
    if (_remainder_x != 0)
    {
        if (_remainder_x > 0)
        {
            // get the next horizontal intersection
            _step_h_x = round(_step_h_x - _remainder_x + (raycast_move_h > 0 ? _cell_size : 0));
        }
        else
        {
            // get the next horizontal intersection
            _step_h_x = round(_step_h_x - _remainder_x - (raycast_move_h > 0 ? 0 : _cell_size));
        }
        
        // if there is slope
        if (_gradient != 0)
        {
            // find the new y point
            _step_h_y = (_gradient * (_step_h_x - _start_x)) + _start_y;
        }
        
    }
    
    // get the distance to the first horizontal intersections
    _ray_delta_h = point_distance(_start_x, _start_y, _step_h_x, _step_h_y);
    
    // if the distance is larger than the ray
    if (_ray_delta_h > _ray_target)
    {
        _test_h = false;
    }
    
}

// if testing vertical collisions
if (_test_v)
{
    // if the point is not on a vertical intersection
    var _remainder_y = _step_v_y mod _cell_size;
    if (_remainder_y != 0)
    {
        if (_remainder_y > 0)
        {
            // get the next vertical intersection
            _step_v_y = round(_step_v_y - _remainder_y + (raycast_move_v > 0 ? _cell_size : 0));
        }
        else
        {
            // get the next vertical intersection
            _step_v_y = round(_step_v_y - _remainder_y - (raycast_move_v > 0 ? 0 : _cell_size));
        }
        
        // if there is slope
        if (_gradient != 0)
        {
            // find the new x point
            _step_v_x = ((_step_v_y - _start_y) / _gradient ) + _start_x;
        }
    
    }
    
    // get the distance to the first vertical intersections
    _ray_delta_v = point_distance(_start_x, _start_y, _step_v_x, _step_v_y);
        
    // if the distance is larger than the ray
    if (_ray_delta_v > _ray_target)
    {
        _test_v = false;
    }
    
}


/**
 * Move Along the Ray Testing for Collisions
 *
 * Move towards each horizontal and veritcal intersection until a tile is found.
 * At each intersection, test the width or height of the bounding box, checking for tiles along the opposite intersection.
 */

// while test can be performed and no collisions have occurred
while ((_test_h || _test_v) && ! _collision_h && ! _collision_v)
{
    // if horizontal collision test can be performed
    // (and either can't test veritcal collision or the horizontal test is closer than the vertical test)
    if (_test_h && ( ! _test_v || _ray_delta_h <= _ray_delta_v))
    {
        _tile_one_way = (raycast_move_h > 0 ? tile_solid_east : tile_solid_west);
        _tile_slope_45_1 = (raycast_move_h > 0 ? tile_solid_45_se : tile_solid_45_sw);
        _tile_slope_45_2 = (raycast_move_h > 0 ? tile_solid_45_ne : tile_solid_45_nw);

        // find the cell this point occupies
        _cell_x = round(_step_h_x / _cell_size);
        _cell_y = floor(_step_h_y / _cell_size);
        
        // if the movement is negative
        if (raycast_move_h < 0)
        {
            _cell_x = _cell_x - 1;
        }
        
        // if the point is on the other intersection
        if (_step_h_y mod _cell_size == 0)
        {
            // if there is no slope and the other movement is negative
            if (_gradient == 0 || raycast_move_v < 0)
            {
                _cell_y = _cell_y - 1;
            }
        }
        
        // get the distance from the point to the TOP LEFT corner of the cell
        _size_delta = point_distance(0, _step_h_y, 0, (_cell_y * _cell_size));
        
        // if the other movement is negative
        if (raycast_move_v < 0)
        {
            // converts the distance to the BOTTOM LEFT corner of the cell
            _size_delta = _cell_size - _size_delta;
        }
        
        // get the total distance to check
        _size_target = (bbox_height + _cell_size + 1);
        
        // while the target size hasn't been reached
        while (_size_delta < _size_target)
        {
            // check tile collision
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_one_way)
            {
                if (_ray_delta_h < _ray_target_h)
                {
                    // update collision states
                    _collision_h = true;
                    _test_h = false;
                    
                    // update the movement values
                    _move_h = _step_h_x - _start_x;
                    _move_v = _step_h_y - _start_y;
                    
                    // update the collision target distance
                    _ray_target_h = point_distance(0, 0, _move_h, _move_v);
                }
            }
            
            else if (_tile_at_point == _tile_slope_45_1 || _tile_at_point == _tile_slope_45_2)
            {
                raycast_slope_x = _step_h_x;
                raycast_slope_y = _step_h_y;
                raycast_collision_slope = false;
                
                if (scr_simulation_11_entity_slope(_start_x, _start_y, _cell_x, _cell_y, _gradient, _ray_target_h, _tile_at_point))
                {
                    raycast_collision_slope = true;
                    
                    _step_h_x = raycast_slope_x;
                    _step_h_y = raycast_slope_y;
                    
                    // update collision states
                    _collision_h = true;
                    _collision_v = true;
                    _test_h = false;
                    _test_v = false;
                    
                    // update the movement values
                    _move_h = _step_h_x - _start_x;
                    _move_v = _step_h_y - _start_y;
                    
                    // update the collision target distance
                    _ray_target_h = point_distance(0, 0, _move_h, _move_v);
                }
            }
            
            // move the cell to the next intersection along the side of the object
            _cell_y = _cell_y + (raycast_move_v >= 0 ? -1 : 1);
            
            // increase the distance traveled
            _size_delta += _cell_size;
        }
        
        // if no collision occurred during this step
        if (_collision_h == false)
        {
            // move along the ray towards the next intersection
            _step_h_x = round(_step_h_x + (_cell_size * sign(raycast_move_h)));
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new y point
                _step_h_y = (_gradient * (_step_h_x - _start_x)) + _start_y;   
            }
            
            // update the distance traveled
            _ray_delta_h = point_distance(_start_x, _start_y, _step_h_x, _step_h_y);
            
            // continue collision until the target distance is reached
            _test_h = (_ray_delta_h < _ray_target);
        
        }
        
    }
    
    // else, if vertical collision test can be performed
    // (and either can't test horizontal collision or the vertical test is closer than the horizontal test)
    else if  (_test_v && ( ! _test_h || _ray_delta_v <= _ray_delta_h))
    {
        _tile_one_way = (raycast_move_v > 0 ? tile_solid_south : tile_solid_north);
        _tile_slope_45_1 = (raycast_move_v > 0 ? tile_solid_45_se : tile_solid_45_ne);
        _tile_slope_45_2 = (raycast_move_v > 0 ? tile_solid_45_sw : tile_solid_45_nw);

        // find the cell this point occupies
        _cell_x = floor(_step_v_x / _cell_size);
        _cell_y = round(_step_v_y / _cell_size);
        
        // if the movement is negative
        if (raycast_move_v < 0)
        {
            _cell_y = _cell_y - 1;
        }
        
        // if the point is on the other intersection
        if (_step_v_x mod _cell_size == 0)
        {
            // if there is no slope and the other movement is negative
            if (_gradient == 0 || raycast_move_h < 0)
            {
                _cell_x = _cell_x - 1;
            }
        }
        
        // get the distance from the point to the TOP LEFT corner of the cell
        _size_delta = point_distance(_step_v_x, 0, (_cell_x * _cell_size), 0);
        
        // if the other movement is negative
        if (raycast_move_h < 0)
        {
            // converts the distance to the TOP RIGHT corner of the cell
            _size_delta = _cell_size - _size_delta;
        }
        
        // get the total distance to check
        _size_target = (bbox_width + _cell_size + 1);
        
        // while the target size hasn't been reached
        while (_size_delta < _size_target)
        {
            // check tile collision
            _tile_at_point = tilemap_get(_collision_tilemap, _cell_x, _cell_y) & tile_index_mask;
            if (_tile_at_point == _tile_solid || _tile_at_point == _tile_one_way)
            {
                if (_ray_delta_v < _ray_target_v)
                {
                    // update collision states
                    _collision_v = true;
                    _test_v = false;
                    
                    // update the movement values
                    _move_h = _step_v_x - _start_x;
                    _move_v = _step_v_y - _start_y;
                    
                    // update the collision target distance
                    _ray_target_v = point_distance(0, 0, _move_h, _move_v);
                }
            }
            
            else if (_tile_at_point == _tile_slope_45_1 || _tile_at_point == _tile_slope_45_2)
            {
                raycast_slope_x = _step_v_x;
                raycast_slope_y = _step_v_y;
                raycast_collision_slope = false;
                
                if (scr_simulation_11_entity_slope(_start_x, _start_y, _cell_x, _cell_y, _gradient, _ray_target_v, _tile_at_point))
                {
                    raycast_collision_slope = true;
                    
                    _step_v_x = raycast_slope_x;
                    _step_v_y = raycast_slope_y;
                    
                    // update collision states
                    _collision_h = true;
                    _collision_v = true;
                    _test_h = false;
                    _test_v = false;
                    
                    // update the movement values
                    _move_h = _step_v_x - _start_x;
                    _move_v = _step_v_y - _start_y;
                    
                    // update the collision target distance
                    _ray_target_v = point_distance(0, 0, _move_h, _move_v);
                }
            }
            
            // move the cell to the next intersection along the side of the object
            _cell_x = _cell_x + (raycast_move_h >= 0 ? -1 : 1);
            
            // increase the distance traveled
            _size_delta += _cell_size;
        }
        
        // if no collision occurred during this step
        if (_collision_v == false)
        {
            // move along the ray towards the next intersection
            _step_v_y = round(_step_v_y + (_cell_size * sign(raycast_move_v)));
            
            // if there is slope
            if (_gradient != 0)
            {
                // find the new x point
                _step_v_x = ((_step_v_y - _start_y) / _gradient ) + _start_x;
            }
            
            // update the distance traveled
            _ray_delta_v = point_distance(_start_x, _start_y, _step_v_x, _step_v_y);
            
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

