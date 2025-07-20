extends Node3D
class_name MapGenerator

@export var grid_map: GridMap
@export var generated_map_size = Vector2i(260, 300)
@export var noise_scale: float = 0.1
@export var height_threshold: float = 0.25
@export var seed_value: int = 0

const TILE_LOW = 0
const TILE_TALL = 5
const TILE_TALL_ALT = 1
const TILE_SLOPE = 2
const TILE_SLOPE_INNER = 3
const TILE_SLOPE_OUTER = 4

const LOW = 0
const TALL = 1

var noise: FastNoiseLite

@onready var grid_map_cell := []

func get_neighbors(x: int, y: int) -> Dictionary:
	var neighbors = {
		"n": null, "ne": null, "e": null, "se": null,
		"s": null, "sw": null, "w": null, "nw": null
	}
	
	if y + 1 < generated_map_size.y:
		neighbors.n = grid_map_cell[x][y + 1]
	if y + 1 < generated_map_size.y and x + 1 < generated_map_size.x:
		neighbors.ne = grid_map_cell[x + 1][y + 1]
	if x + 1 < generated_map_size.x:
		neighbors.e = grid_map_cell[x + 1][y]
	if y - 1 >= 0 and x + 1 < generated_map_size.x:
		neighbors.se = grid_map_cell[x + 1][y - 1]
	if y - 1 >= 0:
		neighbors.s = grid_map_cell[x][y - 1]
	if y - 1 >= 0 and x - 1 >= 0:
		neighbors.sw = grid_map_cell[x - 1][y - 1]
	if x - 1 >= 0:
		neighbors.w = grid_map_cell[x - 1][y]
	if y + 1 < generated_map_size.y and x - 1 >= 0:
		neighbors.nw = grid_map_cell[x - 1][y + 1]
	
	return neighbors

func _ready() -> void:
	noise = FastNoiseLite.new()
	if (seed_value == 0):
		seed_value = randi()
	seed(seed_value)
	noise.seed = seed_value
	noise.frequency = noise_scale

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
	var changes_made = true
	var iteration = 0
	var max_iterations = 10
	
	while changes_made and iteration < max_iterations:
		changes_made = false
		iteration += 1
		
		var pending_changes = []
		
		for x in range(generated_map_size.x):
			for y in range(generated_map_size.y):
				if grid_map_cell[x][y] == LOW:
					var neighbors = get_neighbors(x, y)
					
					var tall_neighbors = 0
					if neighbors.n == TALL:
						tall_neighbors += 1
					if neighbors.s == TALL:
						tall_neighbors += 1
					if neighbors.e == TALL:
						tall_neighbors += 1
					if neighbors.w == TALL:
						tall_neighbors += 1
					
					if tall_neighbors >= 3 or \
					(neighbors.e == TALL and neighbors.w == TALL) or \
					(neighbors.n == TALL and neighbors.s == TALL) or \
					(neighbors.ne == TALL and neighbors.sw == TALL) or \
					(neighbors.nw == TALL and neighbors.se == TALL):
						pending_changes.append(Vector2i(x, y))
		
		for pos in pending_changes:
			grid_map.set_cell_item(Vector3i(pos.x, 0, pos.y), TILE_TALL)
			grid_map_cell[pos.x][pos.y] = TALL
			changes_made = true
					
		

func generate_slopes() -> void:
	var rot_y = {
		0: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(0))),
		90: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(90))),
		180: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(180))),
		270: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(270)))
	}

	for x in range(generated_map_size.x):
		for y in range(generated_map_size.y):
			if grid_map_cell[x][y] == LOW:
				var neighbors = get_neighbors(x, y)
				
				if neighbors.e == TALL and neighbors.w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[0])
				if neighbors.w == TALL and neighbors.e == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[180])
				if neighbors.n == TALL and neighbors.s == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[270])
				if neighbors.s == TALL and neighbors.n == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE, rot_y[90])

				if neighbors.n == TALL and neighbors.w == TALL and neighbors.s == LOW and neighbors.e == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[180])
				if neighbors.n == TALL and neighbors.e == TALL and neighbors.s == LOW and neighbors.w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[270])
				if neighbors.s == TALL and neighbors.e == TALL and neighbors.n == LOW and neighbors.w == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[0])
				if neighbors.s == TALL and neighbors.w == TALL and neighbors.n == LOW and neighbors.e == LOW:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_INNER, rot_y[90])

				var all_cardinal_low = neighbors.s == LOW and neighbors.e == LOW and neighbors.n == LOW and neighbors.w == LOW
				if all_cardinal_low:
					if neighbors.nw == TALL and neighbors.se == LOW and neighbors.ne == LOW and neighbors.sw == LOW:
						grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[180])
					elif neighbors.ne == TALL and neighbors.se == LOW and neighbors.nw == LOW and neighbors.sw == LOW:
						grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[270])
					elif neighbors.se == TALL and neighbors.nw == LOW and neighbors.ne == LOW and neighbors.sw == LOW:
						grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[0])
					elif neighbors.sw == TALL and neighbors.se == LOW and neighbors.ne == LOW and neighbors.nw == LOW:
						grid_map.set_cell_item(Vector3i(x, 0, y), TILE_SLOPE_OUTER, rot_y[90])
				