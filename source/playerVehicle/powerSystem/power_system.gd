extends Node3D
class_name PowerSystem

signal energy_changed(value: float)

@onready var player_vehicle = get_parent() as PlayerVehicle
@onready var power_bar = $PowerBar
@export var maximum_energy: float
var current_energy:float

func change_energy(value: float = 0) -> void:
	current_energy += value
	current_energy = clamp(current_energy, 0, maximum_energy)
	energy_changed.emit(value)
	_update_power_bar()
	if current_energy <= 0:
		Eventbus.energy_depleted.emit()
	print(current_energy)

func decrease_energy(value: float) -> void:
	change_energy(-value)

func initialize_power_system() -> void:
	current_energy = maximum_energy
	power_bar.max_value = maximum_energy
	
func _update_power_bar() -> void:
		power_bar.value = current_energy
