extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.loading_screen)


func _on_source_code_button_pressed() -> void:
	OS.shell_open("https://github.com/6ajmon/kenneygamejam")


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_packed(SceneManager.settings_screen)
