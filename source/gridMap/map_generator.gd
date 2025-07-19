extends Node3D
class_name MapGenerator

@export var grid_map: GridMap
@export var generated_map_size = Vector2i(600, 400)
@export var noise_scale: float = 0.1
@export var height_threshold: float = 0.25
@export var seed_value: int = 0

const TILE_LOW = 0
const TILE_TALL = 6
const TILE_TALL_ALT = 2
const TILE_SLOPE = 3
const TILE_SLOPE_INNER = 4
const TILE_SLOPE_OUTER = 5

const LOW = 0
const TALL = 1

var noise: FastNoiseLite

@onready var grid_map_cell := []

func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.seed = seed_value
	noise.frequency = noise_scale
	generate_map()
	generate_slopes()

func generate_map() -> void:
	grid_map.clear()

	for x in range(generated_map_size.x):
		var row := []
		for y in range(generated_map_size.y):
			var height = noise.get_noise_2d(x, y)
			if height < height_threshold:
				grid_map.set_cell_item(Vector3i(x, 0, y), TILE_LOW)
				row.append(LOW)
			elif height >= height_threshold:
				if randi() % 12 != 0:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_TALL)
				else:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_TALL_ALT)
				row.append(TALL)
		grid_map_cell.append(row)
	
	smooth_map()

func smooth_map() -> void:
	var tall_tile_placed = true
	while tall_tile_placed:
		tall_tile_placed = false
		for x in range(generated_map_size.x):
			for y in range(generated_map_size.y):
				var neighbor_north = null
				var neighbor_south = null
				var neighbor_east = null
				var neighbor_west = null

				if y + 1 < generated_map_size.y:
					neighbor_north = grid_map_cell[x][y + 1]

				if y - 1 >= 0:
					neighbor_south = grid_map_cell[x][y - 1]

				if x + 1 < generated_map_size.x:
					neighbor_east = grid_map_cell[x + 1][y]

				if x - 1 >= 0:
					neighbor_west = grid_map_cell[x - 1][y]

				var tall_neighbors = 0
				if neighbor_north == TALL:
					tall_neighbors += 1
				if neighbor_south == TALL:
					tall_neighbors += 1
				if neighbor_east == TALL:
					tall_neighbors += 1
				if neighbor_west == TALL:
					tall_neighbors += 1
				
				if grid_map_cell[x][y] == LOW:
					if tall_neighbors >= 3 or (neighbor_east == TALL and neighbor_west == TALL) or (neighbor_north == TALL and neighbor_south == TALL):
						grid_map.set_cell_item(Vector3i(x, 0, y), TILE_TALL)
						grid_map_cell[x][y] = TALL
						tall_tile_placed = true
		

func generate_slopes() -> void:
	var rot_y = {
		0: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(0))),
		90: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(90))),
		180: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(180))),
		270: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(270)))
	}

	for x in range(generated_map_size.x):
		for y in range(generated_map_size.y):
			var neighbor_n = null
			var neighbor_ne = null
			var neighbor_e = null
			var neighbor_se = null
			var neighbor_s = null
			var neighbor_sw = null
			var neighbor_w = null
			var neighbor_nw = null

			if y + 1 < generated_map_size.y:
				neighbor_n = grid_map_cell[x][y + 1]
			if y + 1 < generated_map_size.y and x + 1 < generated_map_size.x:
				neighbor_ne = grid_map_cell[x + 1][y + 1]
			if x + 1 < generated_map_size.x:
				neighbor_e = grid_map_cell[x + 1][y]
			if y - 1 >= 0 and x + 1 < generated_map_size.x:
				neighbor_se = grid_map_cell[x + 1][y - 1]
			if y - 1 >= 0:
				neighbor_s = grid_map_cell[x][y - 1]
			if y - 1 >= 0 and x - 1 >= 0:
				neighbor_sw = grid_map_cell[x - 1][y - 1]
			if x - 1 >= 0:
				neighbor_w = grid_map_cell[x - 1][y]
			if y + 1 < generated_map_size.y and x - 1 >= 0:
				neighbor_nw = grid_map_cell[x - 1][y + 1]

			if grid_map_cell[x][y] == LOW:
				if neighbor_e == TALL and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[0])
				if neighbor_w == TALL and neighbor_e == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[180])
				if neighbor_n == TALL and neighbor_s == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[270])
				if neighbor_s == TALL and neighbor_n == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[90])

				if neighbor_n == TALL and neighbor_w == TALL and neighbor_s == LOW and neighbor_e == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[180])
				if neighbor_n == TALL and neighbor_e == TALL and neighbor_s == LOW and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[270])
				if neighbor_s == TALL and neighbor_e == TALL and neighbor_n == LOW and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[0])
				if neighbor_s == TALL and neighbor_w == TALL and neighbor_n == LOW and neighbor_e == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[90])

				if neighbor_nw == TALL and neighbor_se == LOW and neighbor_s == LOW and neighbor_e == LOW and neighbor_ne == LOW and neighbor_sw == LOW and neighbor_n == LOW and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[180])
				if neighbor_ne == TALL and neighbor_se == LOW and neighbor_s == LOW and neighbor_e == LOW and neighbor_nw == LOW and neighbor_sw == LOW and neighbor_n == LOW and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[270])
				if neighbor_se == TALL and neighbor_nw == LOW and neighbor_s == LOW and neighbor_e == LOW and neighbor_ne == LOW and neighbor_sw == LOW and neighbor_n == LOW and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[0])
				if neighbor_sw == TALL and neighbor_se == LOW and neighbor_s == LOW and neighbor_e == LOW and neighbor_ne == LOW and neighbor_nw == LOW and neighbor_n == LOW and neighbor_w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[90])
				
			
