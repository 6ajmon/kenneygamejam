extends Label

const DAY = "Day "

func _process(_delta: float) -> void:
	text = DAY + str(GameData.CurrentRound)
