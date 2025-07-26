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
	GameData.statBoosts.acceleration += acceleration
	if bullets_per_second != 0:
		GameData.statBoosts.bullets_per_second *= bullets_per_second
	if GameData.statBoosts.bullet_range + bullet_range <= 0:
		GameData.statBoosts.bullet_range += bullet_range
	else:
		GameData.statBoosts.bullet_range = 0
	if bullet_size != 0:
		GameData.statBoosts.bullet_size *= bullet_size
	if damage != 0:
		GameData.statBoosts.damage *= damage
	GameData.statBoosts.max_power += max_power
	GameData.statBoosts.max_speed += max_speed
	GameData.statBoosts.pierce += pierce
	GameData.statBoosts.power_usage += power_usage
