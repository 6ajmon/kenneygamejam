extends Control
@onready var day: Label = $Day

func _process(_delta: float) -> void:
	day.text = "Day " + str(GameData.CurrentRound)
