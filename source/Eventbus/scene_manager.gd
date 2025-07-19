extends Node

var failure_scene: PackedScene = preload("res://source/ui/game_over.tscn")
var shop_scene: PackedScene = preload("res://source/ui/shop_ui.tscn")
var main_screen_scene: PackedScene = preload("res://source/ui/starting_screen.tscn")
var loading_screen: PackedScene = preload("res://source/ui/loading_screen.tscn")
var required_soul_quota: int = 10

var souls_collected_this_round: int = 0

func _ready() -> void:
	Eventbus.energy_depleted.connect(_on_energy_depleted)

func _on_energy_depleted() -> void:
	if souls_collected_this_round >= required_soul_quota:
		GameData.AlienSouls += souls_collected_this_round
		get_tree().change_scene_to_packed(shop_scene)
	else:
		get_tree().change_scene_to_packed(failure_scene)
