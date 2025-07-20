extends Control
@onready var day: Label = $Day
@onready var tutorial: Control = $Tutorial
@onready var power_left: Label = $PowerLeft

func _process(_delta: float) -> void:
	day.text = "Day " + str(GameData.CurrentRound)
	if tutorial.visible:
		power_left.visible = false
	else:
		power_left.visible = true
