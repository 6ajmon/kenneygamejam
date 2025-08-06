extends Button
class_name UIButton

@export var shouldTakeFocus: bool

func _ready() -> void:
	if shouldTakeFocus:
		self.grab_focus()

func _on_pressed() -> void:
	if not disabled:
		AudioManager.emit_signal("button_pressed")
	else:
		AudioManager.emit_signal("button_failed")
