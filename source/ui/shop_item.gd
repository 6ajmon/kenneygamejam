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

func set_item(_name : String, _upgrade : Upgrade) -> void:
	item_name.text = _name
	icon.texture = _upgrade.icon
	description.text = _upgrade.description
	upgrade_name = _name
	upgrade = _upgrade
	upgrade_cost = GameData.get_price(_upgrade.rarity)
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
		else:
			var stats : StatBoost = upgrade.scene.instantiate()
			stats.apply()
			print(GameData.StatBoosts.damage)
		set_sold()
		GameData.AlienSouls -= upgrade_cost
		var shop = get_parent().get_parent()
		shop.label.text = str(int(GameData.AlienSouls)) + " souls"
