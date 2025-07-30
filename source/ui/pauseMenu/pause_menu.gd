extends Control

@onready var first_button: Button = $ColorRect/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/MarginContainerLeft/MarginContainer/VBoxContainer/ResumeButton

func _ready() -> void:
	first_button.grab_focus()


func _on_resume_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")


func _on_tutorial_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")


func _on_settings_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")



func _on_restart_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")


func _on_main_menu_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
