extends Control

func _ready() -> void:
	visible = not GameData.tutorial_closed

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("close_tutorial"):
		GameData.tutorial_closed = not GameData.tutorial_closed
		visible = not GameData.tutorial_closed
