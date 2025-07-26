extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/VBoxContainerRight/GoBackButton.grab_focus()
	
func _on_go_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://source/ui/mainMenu/starting_screen.tscn")
