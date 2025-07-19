extends CharacterBody3D
class_name BaseAlien

@export var minimum_speed: float = 5.0
@export var maximum_speed: float = 16.0
var speed: float

@export var player_detection_range: float = 20.0
@export var max_slope_angle: float = 65.0
@export var rotation_speed: float = 6.0

@onready var animation_player: AnimationPlayer = $AlienAnimated/tmpParent/AnimationPlayer
@onready var lifespan_timer: Timer = $AlienLifespan
@onready var health_component: HealthComponent = $HealthComponent

var gravity = 10.0

var distance_check_timer: float = 0.0
var distance_check_interval: float = 0.1
var cached_distance_to_player: float = INF
var cached_player_position: Vector3
var detection_range_squared: float
var is_player_in_range: bool = false

func _ready() -> void:
	speed = randf_range(minimum_speed, maximum_speed)
	detection_range_squared = player_detection_range * player_detection_range
	health_component.died.connect(_on_death)

func _physics_process(delta: float) -> void:
	distance_check_timer += delta
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0
	
	run_from_player(delta)
	move_and_slide()

func run_from_player(delta: float) -> void:
	
	if distance_check_timer >= distance_check_interval:
		distance_check_timer = 0.0
		cached_player_position = GameData.PlayerPosition
		var distance_squared = global_position.distance_squared_to(cached_player_position)
		is_player_in_range = distance_squared <= detection_range_squared
	
	if is_player_in_range:
		lifespan_timer.paused = true
		var escape_direction = (global_position - cached_player_position)
		escape_direction.y = 0
		escape_direction = escape_direction.normalized()
		
		if animation_player and not animation_player.is_playing():
			animation_player.play("walk_animation")
			animation_player.speed_scale = speed / minimum_speed
		
		if escape_direction.length_squared() > 0.01:
			var target_transform = transform.looking_at(global_position + escape_direction, Vector3.UP)
			transform = transform.interpolate_with(target_transform, rotation_speed * delta)
		
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
		lifespan_timer.paused = false
		if animation_player and animation_player.is_playing():
			animation_player.stop()
		
		var lerp_factor = 5.0 * delta
		velocity.x = lerp(velocity.x, 0.0, lerp_factor)
		velocity.z = lerp(velocity.z, 0.0, lerp_factor)


func _on_alien_lifespan_timeout() -> void:
	queue_free()

func _on_death() -> void:
	queue_free()
