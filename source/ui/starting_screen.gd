extends Control

@onready var first_level_scene: PackedScene = preload("res://source/gridMap/grid_map.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(first_level_scene)
