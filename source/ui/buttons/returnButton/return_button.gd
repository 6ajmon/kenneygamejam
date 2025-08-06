extends UIButton
class_name ReturnButton

enum MODE {
	change_scene, 
	queue_free_self
}

@export var current_mode: MODE = MODE.change_scene

signal hide_scene

func _on_pressed() -> void:
	super._on_pressed()
	if current_mode == MODE.change_scene:
		SceneManager.changeScene(SceneManager.previous_scene_path)
	elif current_mode == MODE.queue_free_self:
		emit_signal("hide_scene")
