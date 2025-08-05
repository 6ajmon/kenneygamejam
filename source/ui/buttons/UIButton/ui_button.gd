extends Button
class_name UIButton

@export var shoudTakeFocus: bool

func _ready() -> void:
	if shoudTakeFocus:
		self.grab_focus()

func _on_pressed() -> void:
	if !disabled:
		AudioManager.emit_signal("button_pressed")
	else:
		AudioManager.emit_signal("button_failed")
