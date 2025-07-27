extends Label

const SOULS = " Souls"

func _process(_delta: float) -> void:
	text = str(int(GameData.AlienSouls)) + SOULS
