extends Control

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

func _ready() -> void:
	$BackButton.grab_focus()
	
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.emit_signal("button_pressed")
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.emit_signal("button_pressed")
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)


func _on_back_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	get_tree().change_scene_to_file("res://source/ui/mainMenu/starting_screen.tscn")
