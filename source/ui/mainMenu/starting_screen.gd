extends Control

func _ready():
	AudioManager.emit_signal("menu_music")

func _on_source_button_pressed() -> void:
	OS.shell_open("https://github.com/6ajmon/kenneygamejam")
