extends Node3D
class_name StatBoost

@export var max_power : float
@export var damage : float
@export var pierce : int
@export var bullets_per_second : float
@export var max_speed : float
@export var acceleration : float
@export_range(0, 17.1, 0.1) var bullet_size : float
@export var bullet_range : float
@export var power_usage : float

func apply():
	GameData.StatBoosts.acceleration += acceleration
	GameData.StatBoosts.bullets_per_second += bullets_per_second
	if GameData.StatBoosts.bullet_range + bullet_range <= 0:
		GameData.StatBoosts.bullet_range += bullet_range
	else:
		GameData.StatBoosts.bullet_range = 0
	if bullet_size != 0:
		GameData.StatBoosts.bullet_size *= bullet_size
	if damage != 0:
		GameData.StatBoosts.damage *= damage
	GameData.StatBoosts.max_power += max_power
	GameData.StatBoosts.max_speed += max_speed
	GameData.StatBoosts.pierce += pierce
	GameData.StatBoosts.power_usage += power_usage
