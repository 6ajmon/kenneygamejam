extends Control

@onready var loading_screen: PackedScene = preload("res://source/ui/loading_screen.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(loading_screen)
