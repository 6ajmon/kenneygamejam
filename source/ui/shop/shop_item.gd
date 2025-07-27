extends Control
class_name ShopItem

@onready var icon: TextureRect = $Upgrade/Icon
@onready var item_name: Label = $Upgrade/ItemName
@onready var description: Label = $Upgrade/Description
@onready var button: Button = $Button
@onready var sold: Label = $Sold

var upgrade_name : String
var upgrade : Upgrade
var upgrade_cost : float

func calculate_random_cost(base_cost: float, variation_percent: float = 0.16) -> float:
	return base_cost * randf_range(1.0 - variation_percent, 1.0 + variation_percent)

func set_item(_name : String, _upgrade : Upgrade) -> void:
	item_name.text = _name
	icon.texture = _upgrade.icon
	description.text = _upgrade.description
	upgrade_name = _name
	upgrade = _upgrade
	upgrade_cost = calculate_random_cost(GameData.get_price(_upgrade.rarity))
	button.text = str(int(ceil(upgrade_cost))) + " souls"

func set_sold():
	icon.texture = null
	item_name.text = ""
	description.text = ""
	sold.visible = true
	button.visible = false

func _on_buyButton_pressed() -> void:
	if GameData.AlienSouls >= upgrade_cost:
		if upgrade.type != GameData.upgradeTypes.StatBoost:
			GameData.UpgradesUnlocked.append(upgrade)
			GameData.statBoosts.power_usage += 0.5
			if upgrade.type == GameData.upgradeTypes.Weapon:
				GameData.gunsEquipped += 1
			elif upgrade.type == GameData.upgradeTypes.Turret:
				GameData.turretsEquipped += 1
			elif upgrade.type == GameData.upgradeTypes.DrillWeapon:
				GameData.specialWeaponsEquipped += 1
		else:
			GameData.statBoosts.power_usage -= 0.1
			var stats : StatBoost = upgrade.scene.instantiate()
			stats.apply()
		set_sold()
		GameData.AlienSouls -= upgrade_cost

		Eventbus.item_purchased.emit(upgrade_name, upgrade)
