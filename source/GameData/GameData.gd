extends Node

enum upgradeType {Weapon}

var Upgrades = {
	"Weapon000" : Upgrade.new(upgradeType.Weapon ,"res://tmp/weapon_000.tscn"),
	"Starting Weapon" : Upgrade.new(upgradeType.Weapon, "res://starting_weapon.tscn")
}
