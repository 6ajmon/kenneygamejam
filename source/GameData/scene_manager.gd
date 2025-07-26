extends Node

var failure_scene: PackedScene = preload("res://source/ui/game_over.tscn")
var shop_scene: PackedScene = preload("res://source/ui/shop/shop_ui.tscn")
var main_screen_scene: PackedScene = preload("res://source/ui/mainMenu/starting_screen.tscn")
var loading_screen: PackedScene = preload("res://source/ui/loading_screen.tscn")
var settings_screen: PackedScene = preload("res://source/ui/settings_screen.tscn")
var tutorial_screen: PackedScene = preload("res://source/ui/tutorial.tscn")

var settings_instance: Node = null

func _ready() -> void:
	Eventbus.energy_depleted.connect(_on_energy_depleted)

func _on_energy_depleted() -> void:
	if GameData.SoulsCollectedThisRound >= GameData.RequiredQuota:
		GameData.AlienSouls += GameData.SoulsCollectedThisRound
		get_tree().change_scene_to_packed(shop_scene)
		GameData.CurrentRound += 1
		GameData.randomize_color_palette()
	else:
		get_tree().change_scene_to_packed(failure_scene)
		GameData.set_up_game_data()
	GameData.SoulsCollectedThisRound = 0
