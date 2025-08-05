extends Control

var is_paused: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if is_paused:
			unpause()
		else:
			pause()
		AudioManager.emit_signal("button_pressed")

func pause() -> void:
	visible = true
	is_paused = true
	AudioManager.add_low_pass_filter()
	get_tree().paused = true
	
func unpause() -> void:
	visible = false
	is_paused = false
	AudioManager.remove_low_pass_filter()
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	unpause()


func _on_main_menu_button_pressed() -> void:
	unpause()
