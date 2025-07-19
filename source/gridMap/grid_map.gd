extends GridMap

@export var generator: MapGenerator
@export var player_vehicle: PlayerVehicle
@export var player_camera: PlayerCamera
@export var player_fly_height: float = 1.0
@export var camera_drag_margin: float = 5.0
@export var wall_cell_offset: float = 18.0
var map_size: Vector2i
var level_bounds: AABB

func _ready() -> void:
	spawn_player()
	var used_cells = get_used_cells()
	level_bounds = get_grid_bounds(used_cells)
	var world_min = level_bounds.position * cell_size
	var world_max = (level_bounds.position + level_bounds.size) * cell_size
	
	var wall_offset = wall_cell_offset * cell_size.x
	
	create_wall(
		Vector3(world_min.x + wall_offset, 0, (world_min.z + world_max.z) / 2),
		Vector3(1, 100, world_max.z - world_min.z - 2 * wall_offset)
	)

	create_wall(
		Vector3(world_max.x - wall_offset, 0, (world_min.z + world_max.z) / 2),
		Vector3(1, 100, world_max.z - world_min.z - 2 * wall_offset)
	)

	create_wall(
		Vector3((world_min.x + world_max.x) / 2, 0, world_min.z + wall_offset),
		Vector3(world_max.x - world_min.x - 2 * wall_offset, 100, 1)
	)

	create_wall(
		Vector3((world_min.x + world_max.x) / 2, 0, world_max.z - wall_offset),
		Vector3(world_max.x - world_min.x - 2 * wall_offset, 100, 1)
	)

func spawn_player() -> void:
	map_size = generator.generated_map_size
	player_vehicle.global_transform.origin = Vector3(map_size.x / 2.0, player_fly_height, map_size.y / 2.0)

func get_grid_bounds(cells: Array[Vector3i]) -> AABB:
	if cells.is_empty():
		return AABB()

	var min_pos = cells[0]
	var max_pos = cells[0]

	for cell in cells:
		min_pos = Vector3i(
			min(min_pos.x, cell.x),
			min(min_pos.y, cell.y),
			min(min_pos.z, cell.z)
		)
		max_pos = Vector3i(
			max(max_pos.x, cell.x),
			max(max_pos.y, cell.y),
			max(max_pos.z, cell.z)
		)

	var size = max_pos - min_pos + Vector3i.ONE
	return AABB(min_pos, size)
	

func create_wall(wall_position: Vector3, size: Vector3):
	var wall = StaticBody3D.new()
	var shape = CollisionShape3D.new()
	var box = BoxShape3D.new()
	box.size = size
	shape.shape = box
	wall.position = wall_position
	wall.add_child(shape)
	add_child(wall)
