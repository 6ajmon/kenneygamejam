extends Control
class_name TutorialScreen

@onready var return_button: ReturnButton = $VBoxContainer/HBoxContainer/VBoxContainerRight/GoBackButton

func _ready() -> void:
	return_button.connect("hide_scene", _on_return_button_pressed)

func _on_return_button_pressed() -> void:
	queue_free()
