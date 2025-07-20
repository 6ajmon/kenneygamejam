extends Label

var quota_reached: bool = false

func _ready() -> void:
	update_quota_text()

func _process(_delta: float) -> void:
	if not quota_reached:
		update_quota_text()

func update_quota_text() -> void:
	if GameData.SoulsCollectedThisRound >= GameData.RequiredQuota:
		text = "Quota reached!"
		quota_reached = true
		set_process(false)
	else:
		text = "Quota to reach:"
