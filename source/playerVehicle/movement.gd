extends Node3D
class_name VehicleMovement

@export var max_speed: float = 15.0
@export var acceleration: float = 3.0
@export var deceleration: float = 8.0
@export var turn_speed: float = 3.0 
@export var backward_penalty: float = 0.6
@export var turning_penalty: float = 0
@export var backward_max_speed: float = 9
@export var mouse_timeout: float = 2.0  # Time before switching to controller

var current_speed: float = 0.0
var strafe: float = 0.0
var previous_rotation_y: float = 0.0
var last_mouse_position: Vector2
var mouse_idle_timer: float = 0.0
var use_mouse_input: bool = false

@onready var player: PlayerVehicle = $".."

func _ready() -> void:
	max_speed += GameData.statBoosts.max_speed
	backward_max_speed = 3.0/5.0 * max_speed
	acceleration += GameData.statBoosts.acceleration
	last_mouse_position = get_viewport().get_mouse_position()

func move_and_rotate(delta: float) -> void:
	var is_strafing = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		
	if Input.is_action_pressed("move_forward"):
		current_speed += acceleration * delta
	elif Input.is_action_pressed("move_backward"):
		if current_speed <= 0:
			current_speed -= acceleration * delta * backward_penalty
		else:
			current_speed -= acceleration * delta
	else:
		current_speed = move_toward(current_speed, 0.0, deceleration * delta)
	
	if !is_strafing:
		current_speed = clamp(current_speed, -backward_max_speed, max_speed)
	else:
		current_speed = clamp(current_speed, -backward_max_speed, backward_max_speed)
	
	if Input.is_action_pressed("move_left"):
		strafe -= acceleration * delta * backward_penalty
	elif Input.is_action_pressed("move_right"):
		strafe += acceleration * delta * backward_penalty
	else:
		strafe = move_toward(strafe, 0, deceleration * delta)
	
	strafe = clamp(strafe, -backward_max_speed, backward_max_speed)
	
	var direction := _get_mouse_direction()
	
	if direction.length() > 0.01:
		var target_angle := atan2(-direction.x, -direction.z)
		player.rotation.y = lerp_angle(player.rotation.y, target_angle, turn_speed * delta)
		var angle_change = abs(player.rotation.y - previous_rotation_y)
		previous_rotation_y = player.rotation.y

		var steering_penalty: float = angle_change * turning_penalty
		current_speed = move_toward(current_speed, 0.0, steering_penalty)

	var forward_direction = -player.transform.basis.z.normalized()
	var right_direction = player.transform.basis.x.normalized()

	player.velocity = forward_direction * current_speed + right_direction * strafe 
	player.move_and_slide()

func _get_mouse_direction() -> Vector3:
	var direction := Vector3.ZERO
	var current_mouse_pos := get_viewport().get_mouse_position()
	
	if current_mouse_pos.distance_to(last_mouse_position) > 1.0:
		use_mouse_input = true
		mouse_idle_timer = 0.0
		last_mouse_position = current_mouse_pos
	else:
		mouse_idle_timer += get_process_delta_time()
		if mouse_idle_timer >= mouse_timeout:
			use_mouse_input = false
	
	var controller_input := Vector2(
		Input.get_action_strength("controller_look_right") - Input.get_action_strength("controller_look_left"),
		Input.get_action_strength("controller_look_down") - Input.get_action_strength("controller_look_up")
	)
	
	if controller_input.length() > 0.1:
		use_mouse_input = false
		direction = Vector3(controller_input.y, 0, -controller_input.x).normalized()
	elif use_mouse_input:
		var ray_origin := player.camera.project_ray_origin(current_mouse_pos)
		var ray_dir := player.camera.project_ray_normal(current_mouse_pos)

		var plane_y := player.global_transform.origin.y
		var distance := (plane_y - ray_origin.y) / ray_dir.y
		var target_pos := ray_origin + ray_dir * distance

		direction = (target_pos - player.global_transform.origin)
		direction.y = 0 
		direction = direction.normalized()
	
	return direction

func get_current_speed() -> float:
	return current_speed
