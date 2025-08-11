extends UIButton
class_name SceneButton

@export_file("*.tscn") var scene_path: String

func _on_pressed() -> void:
	super._on_pressed()
	if scene_path:
		SceneManager.changeScene(scene_path)
