extends Node

var failure_scene: PackedScene
var shop_scene: PackedScene = preload("res://source/ui/shop_ui.tscn")
var required_soul_quota: int = 10

var souls_collected_this_round: int = 0

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_node("PowerSystem"):
		player.get_node("PowerSystem").energy_depleted.connect(_on_energy_depleted)

func _on_energy_depleted() -> void:
	if souls_collected_this_round >= required_soul_quota:
		if shop_scene:
			GameData.AlienSouls += souls_collected_this_round
			get_tree().change_scene_to_packed(shop_scene)
	else:
		if failure_scene:
			get_tree().change_scene_to_packed(failure_scene)
