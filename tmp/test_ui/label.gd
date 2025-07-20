extends Label

func _process(_delta: float) -> void:
	text = str(SceneManager.souls_collected_this_round) + " / " + str(SceneManager.required_soul_quota)
