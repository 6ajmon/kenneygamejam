extends Control

@onready var grid_container: GridContainer = $Content/ShopMarginContainer/Shop/ShopItems
@onready var focus_button = $Content/ShopMarginContainer/Shop/ShopItems/ShopItem/Button

var items = []

func _ready() -> void:
	set_up_prices(GameData.CurrentRound)
	reset_shop()
	focus_button.grab_focus()
	AudioManager.emit_signal("shop_entered")

func reset_shop():
	items = grid_container.get_children()
	var keys = GameData.Upgrades.keys()
	for item : ShopItem in items:
		if !keys.is_empty():
			var random_item = keys[randi() % keys.size()]
			keys.erase(random_item)
			item.set_item(random_item, GameData.Upgrades[random_item])
		else:
			item.set_sold()


func _on_continue_button_pressed() -> void:
	AudioManager.emit_signal("button_pressed")
	get_tree().change_scene_to_packed(SceneManager.loading_screen)

func set_up_prices(current_round: int) -> void:
	var multiplier = 1 + 0.1 * current_round
	GameData.commonPrice *= multiplier
	GameData.rarePrice *= multiplier
	GameData.epicPrice *= multiplier
	GameData.legendaryPrice *= multiplier
