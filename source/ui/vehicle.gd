extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("vehicle_float")
