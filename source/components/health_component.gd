extends Node3D
class_name HealthComponent

signal health_changed(new_health: float)
signal died

@export var max_health: float = 100
var current_health: float

func _ready() -> void:
	current_health = max_health
	
func take_damage(damage: float) -> void:
	current_health = max(0, current_health - damage)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		died.emit()

func get_health() -> float:
	return current_health

func get_health_percentage() -> float:
	return current_health / max_health
