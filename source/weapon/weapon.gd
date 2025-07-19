extends Node3D
class_name Weapon

@export var bullets_per_second : int = 10
@export var bullet_speed : float = 20
@export var bullet_scene : PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var muzzle: Marker3D = $Muzzle

const BULLET = preload("res://source/bullet/bullet.tscn")

var on_cooldown : bool = false

func _ready() -> void:
	cooldown_timer.wait_time = 1.0 / bullets_per_second

func shoot(vehicle_speed : float):
	if on_cooldown:
		return
	_init_bullet(vehicle_speed)
	on_cooldown = true
	cooldown_timer.start()

func _init_bullet(vehicle_speed : float):
	var bullet = BULLET.instantiate()
	
	bullet.transform.origin = muzzle.global_transform.origin
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_rotation.y = global_rotation.y
	bullet.speed = bullet_speed + vehicle_speed
	

	
func _on_CooldownTimer_timeout() -> void:
	on_cooldown = false
