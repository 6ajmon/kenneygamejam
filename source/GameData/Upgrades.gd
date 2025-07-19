extends Node
class_name Upgrade

var scene : PackedScene

func _init(scene_path : String) -> void:
	scene = load(scene_path)
