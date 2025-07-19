extends Node3D
class_name HealthComponent

signal damage_recieved(damage_taken: float)
signal died

@export var max_health: float = 100
var current_health: float

func _ready() -> void:
	current_health = max_health
	
func take_damage(damage: float) -> void:
	current_health = max(0, current_health - damage)
	damage_recieved.emit(damage)
	
	if current_health <= 0:
		died.emit()

func get_health() -> float:
	return current_health

func get_health_percentage() -> float:
	return current_health / max_health
