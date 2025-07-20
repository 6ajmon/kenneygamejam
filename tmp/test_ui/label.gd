extends Label

func _physics_process(_delta: float) -> void:
	text = str(int(GameData.SoulsCollectedThisRound)) + " / " + str(int(GameData.RequiredQuota))
