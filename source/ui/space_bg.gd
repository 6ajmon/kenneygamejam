extends Control

@onready var moon = $Mars/Moon
@onready var moon_animation: AnimationPlayer = $Mars/Moon/AnimationPlayer
@export var moon_z_index_increase: int

func _ready() -> void:
	moon_animation.play("moon_movement")

func _process(_delta: float) -> void:
	moon.z_index = z_index + moon_z_index_increase
