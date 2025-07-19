extends CharacterBody3D

@export var player_vehicle: PlayerVehicle
@export var speed: float = 3.0
@export var player_detection_range: float = 6.0

var gravity = 20

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	run_from_player(delta)

func run_from_player(delta) -> void:
	if player_vehicle:
		var direction = global_transform.origin - player_vehicle.global_transform.origin
		direction.y = 0
		direction = direction.normalized()
		
		velocity = direction * speed
		velocity.y -= gravity * delta
		move_and_slide()
	else:
		return
