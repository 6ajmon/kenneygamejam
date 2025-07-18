extends Node3D

@export var grid_map: GridMap
@export var generatedMapSize = Vector2i(600, 400)
@export var noise_scale: float = 0.1
@export var height_threshold: float = 0.25
@export var seed_value: int = 0

const TILE_LOW = 0
const TILE_TALL = 6
const TILE_TALL_ALT = 2
const TILE_SLOPE = 3
const TILE_SLOPE_INNER = 4
const TILE_SLOPE_OUTER = 5

var noise: FastNoiseLite

func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.seed = seed_value
	noise.frequency = noise_scale
	generate_map()

func generate_map() -> void:
	grid_map.clear()

	for x in range(generatedMapSize.x):
		for y in range(generatedMapSize.y):
			var height = noise.get_noise_2d(x, y)
			if height < height_threshold:
				grid_map.set_cell_item(Vector3i(x, 0, y), TILE_LOW)
			elif height > height_threshold:
				if randi() % 12 != 0:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_TALL)
				else:
					grid_map.set_cell_item(Vector3i(x, 0, y), TILE_TALL_ALT)
	

			
