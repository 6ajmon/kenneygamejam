extends CharacterBody3D

var gravity = 5
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	move_and_slide()
