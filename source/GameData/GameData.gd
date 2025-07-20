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
	"Drill": Upgrade.new(upgradeTypes.DrillWeapon, upgradeRarities.Legendary, "res://source/weapon/drill.tscn", "", UpgradesDescriptions.drill)
}

var UpgradesUnlocked = []

var PlayerPosition

var AlienSouls: float
var RequiredQuota: float
var SoulsCollectedThisRound: float
var CurrentRound: int

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

