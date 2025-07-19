extends AnimatableBody3D

@export var speed: float = 5
var direction: Vector3 = Vector3.FORWARD

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !visible:
		visible = true
	#direction.y = -falling_speed
	var velocity = direction * speed
	translate(velocity * delta)

func _on_area_entered(area):
	queue_free()

func get_damage() -> float:
	return 1.0

func _on_queue_free_timer_timeout() -> void:
	queue_free()
