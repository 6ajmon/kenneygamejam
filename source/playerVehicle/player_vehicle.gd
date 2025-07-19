extends CharacterBody3D
class_name PlayerVehicle

@export var max_speed: float = 30.0
@export var acceleration: float = 10.0
@export var deceleration: float = 10.0
@export var turn_speed: float = 2.0  
@export var backward_penalty: float = 0.3
@export var turning_penalty : float = 0
@export var strafe_speed: float = 10

var current_speed: float = 0.0
var previous_rotation_y: float = 0.0


@export var camera: PlayerCamera




func _physics_process(delta: float) -> void:
	
	var is_strafing = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		
	if Input.is_action_pressed("move_forward") and !is_strafing:
		current_speed += acceleration * delta
	elif Input.is_action_pressed("move_backward") and !is_strafing:
		current_speed -= acceleration * delta * backward_penalty
	else:
		current_speed = move_toward(current_speed, 0.0, deceleration * delta)

	current_speed = clamp(current_speed, -max_speed, max_speed)
	
	var strafe := 0.0
	if Input.is_action_pressed("move_left"):
		strafe -= strafe_speed
	if Input.is_action_pressed("move_right"):
		strafe += strafe_speed
	
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)

	var plane_y := global_transform.origin.y
	var distance := (plane_y - ray_origin.y) / ray_dir.y
	var target_pos := ray_origin + ray_dir * distance
	
	var direction := (target_pos - global_transform.origin)
	direction.y = 0  
	if direction.length() > 0.01:
		direction = direction.normalized()
		var target_angle := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
		var angle_change = abs(rotation.y - previous_rotation_y)
		previous_rotation_y = rotation.y

		var steering_penalty: float = angle_change * turning_penalty
		current_speed = move_toward(current_speed, 0.0, steering_penalty)

	
	var forward_direction = -transform.basis.z.normalized()
	var right_direction = transform.basis.x.normalized()


	
	velocity = forward_direction * current_speed + right_direction * strafe 
	print(int(velocity.length()), " m/s")
	move_and_slide()
