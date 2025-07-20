extends Control

@onready var loading_screen: PackedScene = preload("res://source/ui/loading_screen.tscn")
@onready var moon_animation: AnimationPlayer = $SpaceBG/Mars/Moon/AnimationPlayer

func _ready() -> void:
	moon_animation.play("moon_movement")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(loading_screen)


func _on_source_code_button_pressed() -> void:
	OS.shell_open("https://github.com/6ajmon/kenneygamejam")


func _on_options_button_pressed() -> void:
	pass # Replace with function body.
