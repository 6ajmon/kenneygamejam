extends Node3D

@export var alien: BaseAlien
@export var player_vehicle: PlayerVehicle
@export var spawn_min_distance: float = 20.0
@export var alien_wave_size: int = 5
@export var wave_interval: float = 5.0
@export var wave_size_increase: int = 1

var is_round_active: bool
var current_wave: int = 0
var wave_timer: Timer

func _ready() -> void:
	is_round_active = false
	setup_wave_timer()
	start_spawning()

func setup_wave_timer() -> void:
	wave_timer = Timer.new()
	wave_timer.wait_time = wave_interval
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	add_child(wave_timer)

func start_spawning() -> void:
	is_round_active = true
	current_wave = 0
	spawn_aliens()

func stop_spawning() -> void:
	is_round_active = false
	wave_timer.stop()

func spawn_aliens() -> void:
	if not alien or not player_vehicle:
		return
	
	var current_wave_size = alien_wave_size + (current_wave * wave_size_increase)
	
	for i in current_wave_size:
		var spawn_position = get_spawn_position()
		var alien_instance = alien.duplicate()
		alien_instance.global_position = spawn_position
		get_tree().current_scene.add_child(alien_instance)
	
	current_wave += 1
	
	if is_round_active:
		wave_timer.start()

func get_spawn_position() -> Vector3:
	if not player_vehicle:
		return Vector3.ZERO
	
	var player_pos = player_vehicle.global_position
	var angle = randf() * TAU
	var spawn_distance = spawn_min_distance + randf() * 5.0
	
	var spawn_pos = Vector3(
		player_pos.x + cos(angle) * spawn_distance,
		player_pos.y,
		player_pos.z + sin(angle) * spawn_distance
	)
	
	return spawn_pos

func _on_wave_timer_timeout() -> void:
	if is_round_active:
		spawn_aliens()
