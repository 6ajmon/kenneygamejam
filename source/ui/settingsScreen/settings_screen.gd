extends Control
class_name SettingsScreen

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var return_button: ReturnButton = $MainMenuButton

func _ready() -> void:
	return_button.connect("hide_scene", _on_return_button_pressed)
	
func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.emit_signal("button_pressed")
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.emit_signal("button_pressed")
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)

func _on_return_button_pressed() -> void:
	queue_free()
