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
	change_visibility()
	is_paused = true
	AudioManager.add_low_pass_filter()
	get_tree().paused = true
	
func unpause() -> void:
	change_visibility()
	is_paused = false
	AudioManager.remove_low_pass_filter()
	get_tree().paused = false

func change_visibility() -> void:
	visible = !visible
	
func _on_resume_button_pressed() -> void:
	unpause()


func _on_main_menu_button_pressed() -> void:
	unpause()


func _on_tutorial_button_pressed() -> void:
	const scene_path = "res://source/ui/tutorial.tscn"
	var scene = preload(scene_path)
	var scene_instance = scene.instantiate() as TutorialScreen
	scene_instance.visible = true
	add_child(scene_instance)
	scene_instance.return_button.current_mode = scene_instance.return_button.MODE.queue_free_self
	scene_instance.z_index += 10

func _on_settings_button_pressed() -> void:
	const scene_path = "res://source/ui/settingsScreen/settings_screen.tscn"
	var scene = preload(scene_path)
	var scene_instance = scene.instantiate() as SettingsScreen
	scene_instance.visible = true
	add_child(scene_instance)
	scene_instance.return_button.current_mode = scene_instance.return_button.MODE.queue_free_self
	scene_instance.z_index += 10
