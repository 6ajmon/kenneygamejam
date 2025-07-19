extends CharacterBody3D

@export var player_vehicle: PlayerVehicle
@export var minimum_speed: float = 3.0
@export var maximum_speed: float = 10.0
var speed: float
@export var player_detection_range: float = 8.0
@export var max_slope_angle: float = 65.0

var gravity = 10.0

func _ready() -> void:
	speed = randf_range(minimum_speed, maximum_speed)
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0
	
	run_from_player()
	move_and_slide()

func run_from_player() -> void:
	if not player_vehicle:
		return
	
	var player_position = player_vehicle.global_position
	var distance_to_player = global_position.distance_to(player_position)
	
	if distance_to_player <= player_detection_range:
		var escape_direction = (global_position - player_position).normalized()
		
		escape_direction.y = 0
		escape_direction = escape_direction.normalized()
		
		
		if is_on_floor():
			var floor_normal = get_floor_normal()
			var slope_angle = rad_to_deg(floor_normal.angle_to(Vector3.UP))
			
			if slope_angle <= max_slope_angle:
				velocity.x = escape_direction.x * minimum_speed
				velocity.z = escape_direction.z * minimum_speed
			else:
				var slope_direction = floor_normal.cross(Vector3.UP).normalized()
				if slope_direction.dot(escape_direction) < 0:
					slope_direction = -slope_direction
				velocity.x = slope_direction.x * minimum_speed * 0.5
				velocity.z = slope_direction.z * minimum_speed * 0.5
		else:
			velocity.x = escape_direction.x * minimum_speed * 0.3
			velocity.z = escape_direction.z * minimum_speed * 0.3
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		velocity.z = lerp(velocity.z, 0.0, 0.1)
