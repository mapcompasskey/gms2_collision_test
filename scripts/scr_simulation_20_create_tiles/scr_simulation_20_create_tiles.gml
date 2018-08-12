/// @function scr_simulation_20_create_tiles()


/**
 * Tiles
 *
 * The tiles are named for the side or direction that cannot be passed through.
 * The numbers "_45", "_22", "_67", "_15", and "_75" refer to the angle of the slope of the tile.
 * The additional "_1", "_2", and "_3" refer to multiple tiles that make up a single slope and should always be used together.
 */

global.TILE_SIZE = 10;
global.TILE_SOLID = 1;

// one sided
global.TILE_SOLID_WEST = 2;  //  --|
global.TILE_SOLID_EAST = 3;  // |--
global.TILE_SOLID_SOUTH = 4; // ---
global.TILE_SOLID_NORTH = 5; // ___

// 45 degrees
global.TILE_SOLID_45_SE = 10; // ◢
global.TILE_SOLID_45_SW = 30; // ◣
global.TILE_SOLID_45_NE = 20; // ◥
global.TILE_SOLID_45_NW = 40; // ◤

// 22.5 degrees
global.TILE_SOLID_22_SE_1 = 11; // ◢
global.TILE_SOLID_22_SE_2 = 12; // ◢

global.TILE_SOLID_22_SW_1 = 31; // ◣
global.TILE_SOLID_22_SW_2 = 32; // ◣

global.TILE_SOLID_22_NE_1 = 21; // ◥
global.TILE_SOLID_22_NE_2 = 22; // ◥

global.TILE_SOLID_22_NW_1 = 41; // ◤
global.TILE_SOLID_22_NW_2 = 42; // ◤

// 67.5 degrees
global.TILE_SOLID_67_SE_1 = 18; // ◢
global.TILE_SOLID_67_SE_2 =  8; // ◢

global.TILE_SOLID_67_SW_1 =  9; // ◣
global.TILE_SOLID_67_SW_2 = 19; // ◣

global.TILE_SOLID_67_NE_1 =  6; // ◥
global.TILE_SOLID_67_NE_2 = 16; // ◥

global.TILE_SOLID_67_NW_1 = 17; // ◤
global.TILE_SOLID_67_NW_2 =  7; // ◤

// 15 degrees
global.TILE_SOLID_15_SE_1 = 13; // ◢
global.TILE_SOLID_15_SE_2 = 14; // ◢
global.TILE_SOLID_15_SE_3 = 15; // ◢

global.TILE_SOLID_15_SW_1 = 33; // ◣
global.TILE_SOLID_15_SW_2 = 34; // ◣
global.TILE_SOLID_15_SW_3 = 35; // ◣

global.TILE_SOLID_15_NE_1 = 23; // ◥
global.TILE_SOLID_15_NE_2 = 24; // ◥
global.TILE_SOLID_15_NE_3 = 25; // ◥

global.TILE_SOLID_15_NW_1 = 43; // ◤
global.TILE_SOLID_15_NW_2 = 44; // ◤
global.TILE_SOLID_15_NW_3 = 45; // ◤

// 75 degrees
global.TILE_SOLID_75_SE_1 = 48; // ◢
global.TILE_SOLID_75_SE_2 = 38; // ◢
global.TILE_SOLID_75_SE_3 = 28; // ◢

global.TILE_SOLID_75_SW_1 = 29; // ◣
global.TILE_SOLID_75_SW_2 = 39; // ◣
global.TILE_SOLID_75_SW_3 = 49; // ◣

global.TILE_SOLID_75_NE_1 = 26; // ◥
global.TILE_SOLID_75_NE_2 = 36; // ◥
global.TILE_SOLID_75_NE_3 = 46; // ◥

global.TILE_SOLID_75_NW_1 = 47; // ◤
global.TILE_SOLID_75_NW_2 = 37; // ◤
global.TILE_SOLID_75_NW_3 = 27; // ◤


/**
 * Sloped Tiles List
 *
 */

global.SLOPED_TILES_LIST = ds_list_create();

// 45 degrees
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_45_SE);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_45_SW);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_45_NE);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_45_NW);

// 22.5 degrees
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_SE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_SE_2);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_SW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_SW_2);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_NE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_NE_2);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_NW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_22_NW_2);

// 67.5 degrees
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_SE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_SE_2);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_SW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_SW_2);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_NE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_NE_2);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_NW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_67_NW_2);

// 15 degrees
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_SE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_SE_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_SE_3);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_SW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_SW_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_SW_3);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_NE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_NE_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_NE_3);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_NW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_NW_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_15_NW_3);

// 75 degrees
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_SE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_SE_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_SE_3);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_SW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_SW_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_SW_3);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_NE_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_NE_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_NE_3);

ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_NW_1);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_NW_2);
ds_list_add(global.SLOPED_TILES_LIST, global.TILE_SOLID_75_NW_3);


/**
 * Sloped Tiles Information
 *
 * The gradient is the slope (m) of the tile.
 *
 * The cosine of the angle is used to determine the new x position along the slope to redirect the movement.
 * Then the line equation "y = mx + b" is used to find the new y position.
 * When trying to apply the sine of 22.5 degrees to determine the new y position, it was always off for some reason.
 *
 * The tile's x1 and y1 refer to the left most offset inside the tile the line starts from.
 * The tile's x2 and y2 refer to the right most offset inside the tile that the line ends at.
 * Where (0, 0) is the top left, (1, 1) is the bottom right, and (1, 0.5) is the left middle point of a tile when multiplied by the tile size.
 *
 * The bounding box of the object testing for collision needs to be offset so that the point closest to a slope is tested.
 * The position is always reset to the top left corner of the bounding box and the offset of its width and height are added accordingly.
 * Where (0, 0) is the top left and (1, 1) is the bottom right of the bounding box.
 *
 * The "sign of the determinant" is used to determine if a point is on the open or solid side of a sloped tile.
 * This value needs to represent the value of the side that is "open space".
 *
 * 0: gradient
 * 1: cosine of the angle
 * 2: tile x1
 * 3: tile y1
 * 4: tile x2
 * 5: tile y2
 * 6: bbox width offset
 * 7: bbox height offset
 * 8: 0: ceiling tile, 1: floor tile
 * 9: sign of the determinant
 */

var _idx = 0;
var _cosine_45 = 0.70710678118; // cosine(45 degrees)
var _cosine_22 = 0.92387953251; // cosine(22.5 degrees)
var _cosine_67 = 0.38268343236; // cosine(67.5 degrees)
var _cosine_15 = 0.96592582628; // cosine(15 degrees)
var _cosine_75 = 0.2588190451;  // cosine(75 desgrees)


/**
 * 45 Degree Tiles
 *
 */

// 45 degrees, south east ◢
_idx = global.TILE_SOLID_45_SE;
global.TILE_DEFINITIONS[_idx, 0] = -1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 45 degrees, north west ◤
_idx = global.TILE_SOLID_45_NW;
global.TILE_DEFINITIONS[_idx, 0] = -1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 45 degrees, south west ◣
_idx = global.TILE_SOLID_45_SW;
global.TILE_DEFINITIONS[_idx, 0] = 1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 45 degrees, north east ◥
_idx = global.TILE_SOLID_45_NE;
global.TILE_DEFINITIONS[_idx, 0] = 1;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_45;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;


/**
 * 22.5 Degree Tiles
 *
 */

// 22.5 degrees, south east ◢ (1)
_idx = global.TILE_SOLID_22_SE_1;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 22.5 degrees, south east ◢ (2)
_idx = global.TILE_SOLID_22_SE_2;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 22.5 degrees, north west ◤ (1)
_idx = global.TILE_SOLID_22_NW_1;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1; 
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 22.5 degrees, north west ◤ (2)
_idx = global.TILE_SOLID_22_NW_2;
global.TILE_DEFINITIONS[_idx, 0] = -0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;


// 22.5 degrees, south west ◣ (1)
_idx = global.TILE_SOLID_22_SW_1;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 22.5 degrees, south west ◣ (2)
_idx = global.TILE_SOLID_22_SW_2;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 22.5 degrees, north east ◥ (1)
_idx = global.TILE_SOLID_22_NE_1;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.5;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 22.5 degrees, north east ◥ (2)
_idx = global.TILE_SOLID_22_NE_2;
global.TILE_DEFINITIONS[_idx, 0] = 0.5;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_22;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.5;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;


/**
 * 67.5 Degree Tiles
 *
 */

// 67.5 degrees, south east ◢ (1)
_idx = global.TILE_SOLID_67_SE_1;
global.TILE_DEFINITIONS[_idx, 0] = -2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 0.5;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 67.5 degrees, south east ◢ (2)
_idx = global.TILE_SOLID_67_SE_2;
global.TILE_DEFINITIONS[_idx, 0] = -2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0.5;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 67.5 degrees, south west ◣ (1)
_idx = global.TILE_SOLID_67_SW_1;
global.TILE_DEFINITIONS[_idx, 0] = 2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 0.5;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 67.5 degrees, south west ◣ (2)
_idx = global.TILE_SOLID_67_SW_2;
global.TILE_DEFINITIONS[_idx, 0] = 2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0.5;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 67.5 degrees, north east ◥ (1)
_idx = global.TILE_SOLID_67_NE_1;
global.TILE_DEFINITIONS[_idx, 0] = 2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 0.5;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 67.5 degrees, north east ◥ (2)
_idx = global.TILE_SOLID_67_NE_2;
global.TILE_DEFINITIONS[_idx, 0] = 2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0.5;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;
global.TILE_DEFINITIONS[_idx, 9] = -1;


// 67.5 degrees, north west ◤ (1)
_idx = global.TILE_SOLID_67_NW_1;
global.TILE_DEFINITIONS[_idx, 0] = -2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1; 
global.TILE_DEFINITIONS[_idx, 4] = 0.5;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 67.5 degrees, north west ◤ (2)
_idx = global.TILE_SOLID_67_NW_2;
global.TILE_DEFINITIONS[_idx, 0] = -2;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_67;
global.TILE_DEFINITIONS[_idx, 2] = 0.5;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = -1;
global.TILE_DEFINITIONS[_idx, 9] = -1;


/**
 * 15 Degree Tiles
 *
 */

// 15 degrees, south east ◢ (1)
_idx = global.TILE_SOLID_15_SE_1;
global.TILE_DEFINITIONS[_idx, 0] = -0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 15 degrees, south east ◢ (2)
_idx = global.TILE_SOLID_15_SE_2;
global.TILE_DEFINITIONS[_idx, 0] = -0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 15 degrees, south east ◢ (3)
_idx = global.TILE_SOLID_15_SE_3;
global.TILE_DEFINITIONS[_idx, 0] = -0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 15 degrees, south west ◣ (1)
_idx = global.TILE_SOLID_15_SW_1;
global.TILE_DEFINITIONS[_idx, 0] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 15 degrees, south west ◣ (2)
_idx = global.TILE_SOLID_15_SW_2;
global.TILE_DEFINITIONS[_idx, 0] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 15 degrees, south west ◣ (3)
_idx = global.TILE_SOLID_15_SW_3;
global.TILE_DEFINITIONS[_idx, 0] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 15 degrees, north east ◥ (1)
_idx = global.TILE_SOLID_15_NE_1;
global.TILE_DEFINITIONS[_idx, 0] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 15 degrees, north east ◥ (2)
_idx = global.TILE_SOLID_15_NE_2;
global.TILE_DEFINITIONS[_idx, 0] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 15 degrees, north east ◥ (3)
_idx = global.TILE_SOLID_15_NE_3;
global.TILE_DEFINITIONS[_idx, 0] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;


// 15 degrees, north west ◤ (1)
_idx = global.TILE_SOLID_15_NW_1;
global.TILE_DEFINITIONS[_idx, 0] = -0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 15 degrees, north west ◤ (2)
_idx = global.TILE_SOLID_15_NW_2;
global.TILE_DEFINITIONS[_idx, 0] = -0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 15 degrees, north west ◤ (3)
_idx = global.TILE_SOLID_15_NW_3;
global.TILE_DEFINITIONS[_idx, 0] = -0.33333333333;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_15;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;


/**
 * 75 Degree Tiles
 *
 */

// 75 degrees, south east ◢ (1)
_idx = global.TILE_SOLID_75_SE_1;
global.TILE_DEFINITIONS[_idx, 0] = -3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 75 degrees, south east ◢ (2)
_idx = global.TILE_SOLID_75_SE_2;
global.TILE_DEFINITIONS[_idx, 0] = -3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 75 degrees, south east ◢ (3)
_idx = global.TILE_SOLID_75_SE_3;
global.TILE_DEFINITIONS[_idx, 0] = -3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.66666666666
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 75 degrees, south west ◣ (1)
_idx = global.TILE_SOLID_75_SW_1;
global.TILE_DEFINITIONS[_idx, 0] = 3
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 75 degrees, south west ◣ (2)
_idx = global.TILE_SOLID_75_SW_2;
global.TILE_DEFINITIONS[_idx, 0] = 3
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;

// 75 degrees, south west ◣ (3)
_idx = global.TILE_SOLID_75_SW_3;
global.TILE_DEFINITIONS[_idx, 0] = 3
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 1;
global.TILE_DEFINITIONS[_idx, 8] = 1;
global.TILE_DEFINITIONS[_idx, 9] = 1;


// 75 degrees, north east ◥ (1)
_idx = global.TILE_SOLID_75_NE_1;
global.TILE_DEFINITIONS[_idx, 0] = 3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 75 degrees, north east ◥ (2)
_idx = global.TILE_SOLID_75_NE_2;
global.TILE_DEFINITIONS[_idx, 0] = 3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 75 degrees, north east ◥ (3)
_idx = global.TILE_SOLID_75_NE_3;
global.TILE_DEFINITIONS[_idx, 0] = 3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 3] = 0;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 1;
global.TILE_DEFINITIONS[_idx, 6] = 1;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 75 degrees, north west ◤ (1)
_idx = global.TILE_SOLID_75_NW_1;
global.TILE_DEFINITIONS[_idx, 0] = -3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 75 degrees, north west ◤ (2)
_idx = global.TILE_SOLID_75_NW_2;
global.TILE_DEFINITIONS[_idx, 0] = -3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.33333333333;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

// 75 degrees, north west ◤ (3)
_idx = global.TILE_SOLID_75_NW_3;
global.TILE_DEFINITIONS[_idx, 0] = -3;
global.TILE_DEFINITIONS[_idx, 1] = _cosine_75;
global.TILE_DEFINITIONS[_idx, 2] = 0.66666666666;
global.TILE_DEFINITIONS[_idx, 3] = 1;
global.TILE_DEFINITIONS[_idx, 4] = 1;
global.TILE_DEFINITIONS[_idx, 5] = 0;
global.TILE_DEFINITIONS[_idx, 6] = 0;
global.TILE_DEFINITIONS[_idx, 7] = 0;
global.TILE_DEFINITIONS[_idx, 8] = 0;
global.TILE_DEFINITIONS[_idx, 9] = -1;

