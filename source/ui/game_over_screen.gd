extends Control

func _ready() -> void:
	$Proceed.grab_focus()
	
func _on_proceed_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	get_tree().change_scene_to_packed(SceneManager.main_screen_scene)
