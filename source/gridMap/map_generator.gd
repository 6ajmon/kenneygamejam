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

const NEIGHBOR_OFFSETS = [
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1),
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1)
]

func get_neighbors_fast(x: int, y: int) -> Array:
	var neighbors = []
	neighbors.resize(8)
	
	for i in range(8):
		var offset = NEIGHBOR_OFFSETS[i]
		var nx = x + offset.x
		var ny = y + offset.y
		
		if nx >= 0 and nx < generated_map_size.x and ny >= 0 and ny < generated_map_size.y:
			neighbors[i] = grid_map_cell[nx][ny]
		else:
			neighbors[i] = null
	
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
	grid_map_cell.clear()

	grid_map_cell.resize(generated_map_size.x)
	for x in range(generated_map_size.x):
		grid_map_cell[x] = []
		grid_map_cell[x].resize(generated_map_size.y)

	for x in range(generated_map_size.x):
		for y in range(generated_map_size.y):
			var height = noise.get_noise_2d(x, y)
			if height < height_threshold:
				grid_map_cell[x][y] = LOW
			else:
				grid_map_cell[x][y] = TALL
	
	smooth_map()
	
	apply_tiles_to_grid()

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
					var neighbors = get_neighbors_fast(x, y)
					
					var tall_neighbors = 0
					if neighbors[0] == TALL: tall_neighbors += 1
					if neighbors[2] == TALL: tall_neighbors += 1
					if neighbors[4] == TALL: tall_neighbors += 1
					if neighbors[6] == TALL: tall_neighbors += 1
					
					if tall_neighbors >= 3 or \
					(neighbors[2] == TALL and neighbors[6] == TALL) or \
					(neighbors[0] == TALL and neighbors[4] == TALL) or \
					(neighbors[1] == TALL and neighbors[5] == TALL) or \
					(neighbors[7] == TALL and neighbors[3] == TALL):
						pending_changes.append(Vector2i(x, y))
		
		for pos in pending_changes:
			grid_map_cell[pos.x][pos.y] = TALL
			changes_made = true

func apply_tiles_to_grid() -> void:
	var rot_y = {
		0: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(0))),
		90: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(90))),
		180: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(180))),
		270: grid_map.get_orthogonal_index_from_basis(Basis(Vector3.UP, deg_to_rad(270)))
	}

	for x in range(generated_map_size.x):
		for y in range(generated_map_size.y):
			var cell_pos = Vector3i(x, 0, y)
			
			if grid_map_cell[x][y] == TALL:
				if randi() % 12 != 0:
					grid_map.set_cell_item(cell_pos, TILE_TALL)
				else:
					grid_map.set_cell_item(cell_pos, TILE_TALL_ALT)
			else:
				var neighbors = get_neighbors_fast(x, y)
				var tile_set = false
				
				if neighbors[0] == TALL and neighbors[6] == TALL and neighbors[4] == LOW and neighbors[2] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE_INNER, rot_y[180])
					tile_set = true
				elif neighbors[0] == TALL and neighbors[2] == TALL and neighbors[4] == LOW and neighbors[6] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE_INNER, rot_y[270])
					tile_set = true
				elif neighbors[4] == TALL and neighbors[2] == TALL and neighbors[0] == LOW and neighbors[6] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE_INNER, rot_y[0])
					tile_set = true
				elif neighbors[4] == TALL and neighbors[6] == TALL and neighbors[0] == LOW and neighbors[2] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE_INNER, rot_y[90])
					tile_set = true
				
				elif neighbors[2] == TALL and neighbors[6] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE, rot_y[0])
					tile_set = true
				elif neighbors[6] == TALL and neighbors[2] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE, rot_y[180])
					tile_set = true
				elif neighbors[0] == TALL and neighbors[4] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE, rot_y[270])
					tile_set = true
				elif neighbors[4] == TALL and neighbors[0] == LOW:
					grid_map.set_cell_item(cell_pos, TILE_SLOPE, rot_y[90])
					tile_set = true
				
				elif neighbors[4] == LOW and neighbors[2] == LOW and neighbors[0] == LOW and neighbors[6] == LOW:
					if neighbors[7] == TALL and neighbors[3] == LOW and neighbors[1] == LOW and neighbors[5] == LOW:
						grid_map.set_cell_item(cell_pos, TILE_SLOPE_OUTER, rot_y[180])
						tile_set = true
					elif neighbors[1] == TALL and neighbors[3] == LOW and neighbors[7] == LOW and neighbors[5] == LOW:
						grid_map.set_cell_item(cell_pos, TILE_SLOPE_OUTER, rot_y[270])
						tile_set = true
					elif neighbors[3] == TALL and neighbors[7] == LOW and neighbors[1] == LOW and neighbors[5] == LOW:
						grid_map.set_cell_item(cell_pos, TILE_SLOPE_OUTER, rot_y[0])
						tile_set = true
					elif neighbors[5] == TALL and neighbors[3] == LOW and neighbors[1] == LOW and neighbors[7] == LOW:
						grid_map.set_cell_item(cell_pos, TILE_SLOPE_OUTER, rot_y[90])
						tile_set = true
				
				if not tile_set:
					grid_map.set_cell_item(cell_pos, TILE_LOW)
				
