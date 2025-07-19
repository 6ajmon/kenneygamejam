extends Node3D
class_name Weapon

@export var bullets_per_second : int = 10
@export var bullet_speed : float = 50

const BULLET = preload("res://source/bullet/bullet.tscn")
@onready var cooldown_timer: Timer = $CooldownTimer

var on_cooldown : bool = false

func _ready() -> void:
	cooldown_timer.wait_time = 1/float(bullets_per_second)

func shoot(direction : Vector3):
	if !on_cooldown:
		init_bullet(direction)
		
		on_cooldown = true
		cooldown_timer.start()

func init_bullet(direction : Vector3) -> void:
	var bullet = BULLET.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform.origin = global_transform.origin
	bullet.velocity = direction.normalized() * bullet_speed

func _on_timer_timeout() -> void:
	on_cooldown = false
