extends Node3D

var velocity: Vector3 = Vector3.ZERO

func _ready():
	pass

func _process(delta: float) -> void:
	translate(velocity * delta)
