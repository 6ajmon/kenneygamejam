extends Node
class_name Upgrade

var scene : PackedScene
var type
var icon : Texture2D
var description : String
var rarity : int

func _init(_type, _rarity : int, scene_path : String, _icon_path : String, _description : String) -> void:
	type = _type
	scene = load(scene_path)
	icon = load(_icon_path) if _icon_path != "" and ResourceLoader.exists(_icon_path) else null
	description = _description
	rarity = _rarity
