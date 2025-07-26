extends Node

enum upgradeTypes {Weapon, DrillWeapon, StatBoost, Turret}

enum upgradeRarities {Common, Rare, Epic, Legendary}

var commonPrice: float
var rarePrice: float
var epicPrice: float
var legendaryPrice: float

var Upgrades = {
	#Stats
	"Damage+" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Rare, "res://source/statBoosts/MediumDamageBoost.tscn","", UpgradesDescriptions.medium_damage_boost),
	"Damage++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Epic, "res://source/statBoosts/LargeDamageBoost.tscn","", UpgradesDescriptions.large_damage_boost),
	"Damage+++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Legendary,"res://source/statBoosts/legendary_damage_boost.tscn" ,"", UpgradesDescriptions.legendary_damage_boost),
	
	"Bullets+" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Rare, "res://source/statBoosts/medium_bullets_up.tscn","", UpgradesDescriptions.medium_bullets_up),
	"Bullets++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Epic, "res://source/statBoosts/large_bullets_up.tscn","", UpgradesDescriptions.large_bullets_up),
	"Bullets+++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Legendary, "res://source/statBoosts/legendary_bullets_up.tscn","", UpgradesDescriptions.legendary_bullets_up),
	
	"Vehicle+" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Rare, "res://source/statBoosts/medium_vehicle_up.tscn","", UpgradesDescriptions.medium_vehicle_up),
	"Vehicle++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Epic, "res://source/statBoosts/large_vehicle_up.tscn","", UpgradesDescriptions.large_vehicle_up),
	"Vehicle+++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Legendary, "res://source/statBoosts/legendary_bullets_up.tscn","", UpgradesDescriptions.legendary_vehicle_up),
	
	"Battery+" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Common, "res://source/statBoosts/small_powerup.tscn","", UpgradesDescriptions.small_power_up),
	"Battery++" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Rare, "res://source/statBoosts/medium_powerup.tscn","", UpgradesDescriptions.medium_power_up),
	"Ultimate Power" : Upgrade.new(upgradeTypes.StatBoost, upgradeRarities.Legendary, "res://source/statBoosts/ultimate_power.tscn" ,"", UpgradesDescriptions.ultimate_power),
	#Weapons
	"Weapon000" : Upgrade.new(upgradeTypes.Weapon, upgradeRarities.Common,"res://source/weapon/Weapons/weapon_000.tscn", "res://assets/Icons/blaster-g.png", UpgradesDescriptions.weapon000),
	"Starter": Upgrade.new(upgradeTypes.Weapon, upgradeRarities.Common,"res://source/weapon/Weapons/starting_weapon.tscn","res://assets/Icons/blaster-g.png", UpgradesDescriptions.starting_weapon ),
	"Sniper": Upgrade.new(upgradeTypes.Weapon, upgradeRarities.Epic, "res://source/weapon/Weapons/sniper.tscn","res://assets/Icons/blaster-f.png", UpgradesDescriptions.sniper),
	"Drill": Upgrade.new(upgradeTypes.DrillWeapon, upgradeRarities.Legendary, "res://source/weapon/Weapons/drill.tscn", "res://assets/Icons/drill.png", UpgradesDescriptions.drill),
	"TurretSingle": Upgrade.new(upgradeTypes.Turret, upgradeRarities.Epic, "res://source/weapon/turret_single.tscn", "res://assets/Icons/turret_single.png", UpgradesDescriptions.turret_single),
	"TurretDouble": Upgrade.new(upgradeTypes.Turret, upgradeRarities.Legendary, "res://source/weapon/turret_double.tscn", "res://assets/Icons/turret_double.png", UpgradesDescriptions.turret_double)
}

var UpgradesUnlocked = []
var statBoosts : StatBoost 

var PlayerPosition
var PlayerRotation: float

var AlienSouls: float
var RequiredQuota: float
var SoulsCollectedThisRound: float
var CurrentRound: int

var current_color_palette: Dictionary

var color_palettes = [
	# red orange
	{
		"low_color": Color(0.83, 0.35, 0.31, 1.0),
		"tall_color": Color(0.57, 0.16, 0.13, 1.0)
	},
	# blue green
	{
		"low_color": Color(0.49, 0.67, 0.82, 1.0),
		"tall_color": Color(0.23, 0.53, 0.36, 1.0)
	},
	# green purple
	{
		"low_color": Color(0.39, 0.8, 0.7, 1.0),
		"tall_color": Color(0.5, 0.35, 0.78, 1.0)
	},
	# grey purple
	{
		"low_color": Color(0.27, 0.25, 0.32, 1.0),
		"tall_color": Color(0.24, 0.32, 0.42, 1)
	},
	# brown yellow
	{
		"low_color": Color(0.65, 0.49, 0.38, 1),
		"tall_color": Color(0.49, 0.35, 0.27, 1.0)
	},
	# white blue
	{
		"low_color": Color(0.29, 0.58, 0.69, 1),
		"tall_color": Color(0.2, 0.3, 0.34, 1.0)
	}
]


func _ready() -> void:
	PlayerRotation = 0.0
	set_up_game_data()

func set_up_game_data() -> void:
	statBoosts = StatBoost.new() 
	UpgradesUnlocked.clear()
	statBoosts.damage = 1
	statBoosts.bullet_size = 1
	statBoosts.bullets_per_second = 1
	UpgradesUnlocked.append(Upgrades["Starter"])
	# UpgradesUnlocked.append(Upgrades["TurretDouble"])
	# UpgradesUnlocked.append(Upgrades["Damage+++"])
	# var damage_upgrade : StatBoost = Upgrades["Damage+++"].scene.instantiate()
	# damage_upgrade.apply()
	AlienSouls = 0
	RequiredQuota = 0
	SoulsCollectedThisRound = 0
	CurrentRound = 1
	commonPrice = 35
	rarePrice = 50
	epicPrice = 70
	legendaryPrice = 100
	current_color_palette = color_palettes[0]

func _on_soul_collected(value: float) -> void:
	SoulsCollectedThisRound += value

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
