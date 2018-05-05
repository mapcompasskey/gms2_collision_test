/// @function scr_simulation_3_entity_create()


/**
 * Set Instance Variables
 *
 */

// values
tile_size = global.TILE_SIZE;

// collision tilemap
collision_tilemap = global.COLLISION_TILEMAP;

// movement
var speed_min = 50;
var speed_max = 150;
velocity_x = random_range(speed_min, speed_max) * (irandom(1) ? 1 : -1);
velocity_y = random_range(speed_min, speed_max) * (irandom(1) ? 1 : -1);

move_h = 0;
move_v = 0;

new_move_h = 0;
new_move_v = 0;

new_move_list = ds_list_create();
new_move_list[| 0] = new_move_h;
new_move_list[| 1] = new_move_v;

// states
collision_h = false;
collision_v = false;

// drawing
the_sprite = spr_simulation_15px;
switch (irandom(4))
{
    case 0: the_sprite = spr_simulation_15px; break;
    case 1: the_sprite = spr_simulation_10px; break;
    case 2: the_sprite = spr_simulation_8x6px; break;
    case 3: the_sprite = spr_simulation_6px; break;
    case 4: the_sprite = spr_simulation_1px; break;
}

sprite_index = the_sprite;
mask_index = the_sprite;

bbox_width = sprite_get_bbox_right(sprite_index) - sprite_get_bbox_left(sprite_index)
bbox_height = sprite_get_bbox_bottom(sprite_index) - sprite_get_bbox_top(sprite_index)

sprite_bbox_left = sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_right = sprite_get_bbox_right(sprite_index) - sprite_get_xoffset(sprite_index);
sprite_bbox_bottom = sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index);
sprite_bbox_top = sprite_get_bbox_top(sprite_index) - sprite_get_yoffset(sprite_index);

// ds lists
bbox_points = ds_list_create();
