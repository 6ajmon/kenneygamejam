extends Label

func _physics_process(_delta: float) -> void:
	text = str(GameData.SoulsCollectedThisRound) + " / " + str(GameData.RequiredQuota)
