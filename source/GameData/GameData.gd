extends Node

enum upgradeTypes {Weapon}

var Upgrades = {
	"Weapon000" : Upgrade.new(Weapon, "res://tmp/weapon_000.tscn"),
	"Starting Weapon": Upgrade.new(Weapon,"res://source/weapon/starting_weapon.tscn"),
	"Sniper": Upgrade.new(Weapon, "res://source/weapon/sniper.tscn")
}
var PlayerPosition
var AlienSouls: float
