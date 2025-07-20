extends Control
@onready var tutorial: Control = $Tutorial

func _process(_delta: float) -> void:
	if Input.is_action_pressed("close_tutorial") or GameData.tutorial_closed:
		if tutorial:
			GameData.tutorial_closed = true
			tutorial.queue_free()
