extends Label

func _process(_delta: float) -> void:
	text = "Day " + str(GameData.CurrentRound)
