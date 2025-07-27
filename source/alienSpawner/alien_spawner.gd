extends Node3D
class_name AlienSpawner

@export var alien_scenes: Array[PackedScene] = []
@export var spawn_min_distance: float = 23.0
@export var alien_wave_size: int = 6
@export var wave_interval: float = 1.0
@export var wave_size_increase: int = 0
@export var spawn_delay_between_aliens: float = 0.25
@export var spawn_distance_variance: float = 6.0

var is_round_active: bool
var current_wave: int = 0
var wave_timer: Timer
var is_spawning: bool = false

func _ready() -> void:
	alien_scenes.append(preload("res://source/enemies/base_alien.tscn"))
	alien_scenes.append(preload("res://source/enemies/giga_alien.tscn"))
	alien_wave_size += GameData.CurrentRound
	is_round_active = false
	setup_wave_timer()

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
	if alien_scenes.is_empty() or is_spawning:
		return
	
	is_spawning = true
	var current_wave_size = alien_wave_size + (current_wave * wave_size_increase)
	
	for i in current_wave_size:
		var spawn_position = get_spawn_position()
		var random_alien_scene: PackedScene
		if randf() <= 1.0/6.0:
			random_alien_scene = alien_scenes[1] if alien_scenes.size() > 1 else alien_scenes[0]
		else:
			random_alien_scene = alien_scenes[0]
		
		var alien_instance = random_alien_scene.instantiate()
		add_child(alien_instance)
		alien_instance.visible = true
		alien_instance.global_position = spawn_position
		
		if spawn_delay_between_aliens > 0 and i < current_wave_size - 1:
			await get_tree().create_timer(spawn_delay_between_aliens).timeout
	
	current_wave += 1
	is_spawning = false
	
	if is_round_active:
		wave_timer.start()

func get_spawn_position() -> Vector3:
	
	var player_pos = GameData.PlayerPosition
	var angle = randf() * TAU
	var spawn_distance = spawn_min_distance + randf() * spawn_distance_variance
	
	var spawn_pos = Vector3(
		player_pos.x + cos(angle) * spawn_distance,
		player_pos.y - 0.25,
		player_pos.z + sin(angle) * spawn_distance
	)
	
	return spawn_pos

func _on_wave_timer_timeout() -> void:
	if is_round_active:
		spawn_aliens()
