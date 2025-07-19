extends Node

enum upgradeTypes {Weapon, DrillWeapon}

var Upgrades = {
	"Weapon000" : Upgrade.new(Weapon, "res://tmp/weapon_000.tscn"),
	"Starting Weapon": Upgrade.new(Weapon,"res://source/weapon/starting_weapon.tscn"),
	"Sniper": Upgrade.new(Weapon, "res://source/weapon/sniper.tscn"),
	"Drill": Upgrade.new(DrillWeapon, "res://source/weapon/drill.tscn")
}

var PlayerPosition
var AlienSouls: float
