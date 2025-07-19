extends AnimatableBody3D

@export var speed: float = 50.0
var direction: Vector3 = Vector3.FORWARD


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !visible:
		visible = true
	translate(direction * speed * delta)

func _on_area_entered(area):
	queue_free()


func _on_queue_free_timer_timeout() -> void:
	queue_free()
