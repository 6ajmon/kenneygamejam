extends CharacterBody3D

@export var max_speed: float = 60.0
@export var acceleration: float = 30.0
@export var deceleration: float = 50.0
@export var turn_speed: float = 4

var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		current_speed += acceleration * delta
	elif Input.is_action_pressed("move_backward"):
		current_speed -= acceleration * delta
	else:
		current_speed = move_toward(current_speed, 0.0, deceleration * delta)

	current_speed = clamp(current_speed, -max_speed, max_speed)

	if Input.is_action_pressed("turn_left"):
		rotation.y += turn_speed * delta 
	elif Input.is_action_pressed("turn_right"):
		rotation.y -= turn_speed * delta 

	var forward_direction = -transform.basis.z.normalized()
	velocity = forward_direction * current_speed


	move_and_slide()
