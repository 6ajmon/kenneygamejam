extends Node3D
class_name Turret

@export var damage: float = 15.0
@export var shots_per_second: float = 2.0
@export var detection_range: float = 30.0
@export var bullet_speed: float = 25.0
@export var rotation_speed: float = 36.0
@export var pierce: int = 1

@onready var bullet_scene: PackedScene = preload("res://source/weapon/bullet/bullet.tscn")

@onready var detection_area: Area3D = $DetectionArea
@onready var turret_body: Node3D = $TurretBody
@onready var fire_points: Array[Marker3D] = []

var targets_in_range: Array[Node3D] = []
var current_target: Node3D = null
var shoot_timer: Timer
var can_shoot: bool = true

func _ready() -> void:
	setup_detection_area()
	
	setup_fire_points()
	
	setup_shoot_timer()
	
	if detection_area:
		detection_area.body_entered.connect(_on_target_entered)
		detection_area.body_exited.connect(_on_target_exited)

func setup_detection_area() -> void:
	if detection_area and detection_area.has_method("get_child"):
		var collision_shape = detection_area.get_child(0)
		if collision_shape and collision_shape is CollisionShape3D:
			var shape = collision_shape.shape
			if shape is SphereShape3D:
				shape.radius = detection_range

func setup_fire_points() -> void:
		fire_points = _find_markers_recursive(turret_body)

func _find_markers_recursive(node: Node) -> Array[Marker3D]:
	var markers: Array[Marker3D] = []
	
	for child in node.get_children():
		if child is Marker3D:
			markers.append(child)
		else:
			markers.append_array(_find_markers_recursive(child))
	
	return markers

func setup_shoot_timer() -> void:
	shoot_timer = Timer.new()
	shoot_timer.wait_time = 1.0 / (shots_per_second * GameData.statBoosts.bullets_per_second)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)

func _physics_process(delta: float) -> void:
	update_target()
	aim_at_target(delta)
	
	if current_target and can_shoot:
		shoot()

func update_target() -> void:
	targets_in_range = targets_in_range.filter(func(target): return is_instance_valid(target))
	
	if targets_in_range.size() > 0:
		var closest_target = null
		var closest_distance = INF
		
		for target in targets_in_range:
			var distance = global_position.distance_to(target.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_target = target
		
		current_target = closest_target
	else:
		current_target = null

func aim_at_target(delta: float) -> void:
	if not current_target or not turret_body:
		return
		
	var target_position = current_target.global_position
	
	var current_transform = turret_body.global_transform
	var target_transform = current_transform.looking_at(target_position, Vector3.UP)
	
	var current_quat = current_transform.basis.get_rotation_quaternion()
	var target_quat = target_transform.basis.get_rotation_quaternion()
	var lerped_quat = current_quat.slerp(target_quat, rotation_speed * delta)
	
	turret_body.global_transform.basis = Basis(lerped_quat)

func shoot() -> void:
	if not can_shoot or fire_points.size() == 0:
		return
	
	can_shoot = false
	shoot_timer.start()
	AudioManager.emit_signal("player_shoot")
	for fire_point in fire_points:
		spawn_bullet(fire_point)

func spawn_bullet(fire_point: Marker3D) -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = fire_point.global_transform
	bullet.speed = bullet_speed
	bullet.damage = damage


func _on_target_entered(body: Node3D) -> void:
	if body is BaseAlien or body.is_in_group("enemies"):
		if body not in targets_in_range:
			targets_in_range.append(body)

func _on_target_exited(body: Node3D) -> void:
	if body in targets_in_range:
		targets_in_range.erase(body)
	
	if body == current_target:
		current_target = null

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
