extends Control

@export var target_scene_path: String = "res://source/gridMap/grid_map.tscn"

var load_state = null

func _ready() -> void:
	load_state = ResourceLoader.load_threaded_request(target_scene_path)

func _process(_delta) -> void:
	if load_state == null:
		return

	var status = ResourceLoader.load_threaded_get_status(target_scene_path)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene_res = ResourceLoader.load_threaded_get(target_scene_path)
		var new_scene = scene_res.instantiate()

		GameData.RequiredQuota = get_required_quota(GameData.CurrentRound)
		get_tree().root.add_child(new_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = new_scene

func get_required_quota(current_round: float) -> int:
	return current_round * 10
