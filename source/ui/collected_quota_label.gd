extends Label

func _process(_delta: float) -> void:
	text = str(int(GameData.SoulsCollectedThisRound)) + " / " + str(int(GameData.RequiredQuota))
