extends Node

enum upgradeTypes {Weapon, DrillWeapon}

var Upgrades = {
	"Weapon000" : Upgrade.new(Weapon, 13, "res://tmp/weapon_000.tscn", "res://assets/Icons/blaster-g.png", UpgradesDescriptions.weapon000),
	"Starter": Upgrade.new(Weapon, 3,"res://source/weapon/starting_weapon.tscn","res://assets/Icons/blaster-g.png", UpgradesDescriptions.starting_weapon ),
	"Sniper": Upgrade.new(Weapon, 20, "res://source/weapon/sniper.tscn","res://assets/Icons/blaster-f.png", UpgradesDescriptions.sniper),
	"Drill": Upgrade.new(DrillWeapon, 10, "res://source/weapon/drill.tscn", "", UpgradesDescriptions.drill)
}

var PlayerPosition
var AlienSouls: int = 23
