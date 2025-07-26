extends Control

@onready var moon_animation: AnimationPlayer = $Mars/Moon/AnimationPlayer

func _ready() -> void:
	moon_animation.play("moon_movement")
