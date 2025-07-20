extends Node

enum upgradeTypes {Weapon, DrillWeapon}

enum upgradeRarities {Common, Rare, Epic, Legendary}

var commonPrice: float
var rarePrice: float
var epicPrice: float
var legendaryPrice: float

var Upgrades = {
	"Weapon000" : Upgrade.new(upgradeTypes.Weapon, upgradeRarities.Common, "res://tmp/weapon_000.tscn", "res://assets/Icons/blaster-g.png", UpgradesDescriptions.weapon000),
	"Starter": Upgrade.new(upgradeTypes.Weapon, upgradeRarities.Common,"res://source/weapon/starting_weapon.tscn","res://assets/Icons/blaster-g.png", UpgradesDescriptions.starting_weapon ),
	"Sniper": Upgrade.new(upgradeTypes.Weapon, upgradeRarities.Epic, "res://source/weapon/sniper.tscn","res://assets/Icons/blaster-f.png", UpgradesDescriptions.sniper),
	"Drill": Upgrade.new(upgradeTypes.DrillWeapon, upgradeRarities.Legendary, "res://source/weapon/drill.tscn", "res://assets/Icons/blaster-f.png", UpgradesDescriptions.drill)
}

var UpgradesUnlocked = []

var PlayerPosition

var AlienSouls: float
var RequiredQuota: float
var SoulsCollectedThisRound: float
var CurrentRound: int

var current_color_palette

var color_palettes = [
	# red orange
	{
		"low_color": Color(0.83, 0.35, 0.31, 1.0),
		"tall_color": Color(0.57, 0.16, 0.13, 1.0)
	},
	# blue green
	{
		"low_color": Color(0.1, 0.5, 0.9, 1.0),
		"tall_color": Color(0.3, 1.0, 0.1, 1.0)
	}
]


func _ready() -> void:
	set_up_game_data()

func set_up_game_data() -> void:
	UpgradesUnlocked.append(Upgrades["Starter"])
	AlienSouls = 0
	RequiredQuota = 10
	SoulsCollectedThisRound = 0
	CurrentRound = 1
	commonPrice = 16
	rarePrice = 25
	epicPrice = 36
	legendaryPrice = 50
	current_color_palette = color_palettes[0]

func randomize_color_palette() -> void:
	var random_index = (randi() % color_palettes.size())
	current_color_palette = color_palettes[random_index]

func get_current_color_palette() -> Dictionary:
	if current_color_palette == null:
		randomize_color_palette()
	return current_color_palette

func get_low_tile_color() -> Color:
	return get_current_color_palette()["low_color"]

func get_tall_tile_color() -> Color:
	return get_current_color_palette()["tall_color"]

func get_price(upgrade_rarity: int) -> float:
	match upgrade_rarity:
		upgradeRarities.Common:
			return commonPrice
		upgradeRarities.Rare:
			return rarePrice
		upgradeRarities.Epic:
			return epicPrice
		upgradeRarities.Legendary:
			return legendaryPrice
	return 0

var tutorial_closed = false
