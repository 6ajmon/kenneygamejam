extends Control
class_name ShopItem

@onready var icon: TextureRect = $Upgrade/Icon
@onready var item_name: Label = $Upgrade/ItemName
@onready var description: Label = $Upgrade/Description
@onready var button: Button = $Button
@onready var sold: Label = $Sold

var upgrade_name : String
var upgrade : Upgrade
var cost : int

func set_item(_name : String, _upgrade : Upgrade) -> void:
	item_name.text = _name
	icon.texture = _upgrade.icon
	description.text = _upgrade.description
	upgrade_name = _name
	upgrade = _upgrade
	cost = upgrade.cost
	button.text = str(cost) + "souls"

func set_sold():
	icon.texture = null
	item_name.text = ""
	description.text = ""
	sold.visible = true
	button.visible = false


func _on_buyButton_pressed() -> void:
	if GameData.AlienSouls >= cost:
		GameData.UpgradesUnlocked.append(upgrade)
		set_sold()
		GameData.AlienSouls -= cost
		var shop = get_parent().get_parent()
		shop.label.text = str(GameData.AlienSouls) + " souls"
