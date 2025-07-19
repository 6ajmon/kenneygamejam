extends Node
class_name Upgrade


var scene : PackedScene
var type 

func _init(_type, scene_path : String) -> void:
	type = _type
	scene = load(scene_path)
