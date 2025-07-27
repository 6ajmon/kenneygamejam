extends Control


func _ready():
	$Buttons/PlayButton.grab_focus()
	AudioManager.emit_signal("menu_music")

func _on_play_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	get_tree().change_scene_to_packed(SceneManager.loading_screen)


func _on_source_code_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	OS.shell_open("https://github.com/6ajmon/kenneygamejam")


func _on_options_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	get_tree().change_scene_to_packed(SceneManager.settings_screen)


func _on_tutorial_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	get_tree().change_scene_to_packed(SceneManager.tutorial_screen)
