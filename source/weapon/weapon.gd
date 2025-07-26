extends Node3D
class_name Weapon

@export var bullets_per_second : float = 10
@export var bullet_speed : float = 20
@export var damage : float = 10
@export var pierce : float = 0

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var muzzle: Marker3D = $Muzzle


@export var BULLET : PackedScene = preload("res://source/weapon/bullet/bullet.tscn")

@onready var audio_player = $AudioStreamPlayer


var on_cooldown : bool = false

func _ready() -> void:
	cooldown_timer.wait_time = 1.0 / (bullets_per_second * GameData.statBoosts.bullets_per_second)

func shoot(vehicle_speed : float):
	if on_cooldown:
		return
	_init_bullet(vehicle_speed)
	on_cooldown = true
	cooldown_timer.start()
	audio_player.play()

func _init_bullet(vehicle_speed : float):
	var bullet = BULLET.instantiate()
	
	bullet.transform.origin = muzzle.global_transform.origin
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_rotation.y = global_rotation.y
	bullet.speed = bullet_speed + vehicle_speed
	bullet.damage = damage
	bullet.pierce = pierce
	
func _on_CooldownTimer_timeout() -> void:
	on_cooldown = false
