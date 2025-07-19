extends Node3D

signal energy_decreased(value: float)
signal energy_depleted()

@onready var player_vehicle = get_parent() as PlayerVehicle
@export var maximum_energy: float
var current_energy:float

func decrease_energy(value: float) -> void:
	current_energy -= value
	energy_decreased.emit(value)
	if current_energy <= 0:
		energy_depleted.emit()

func initialize_power_system() -> void:
	current_energy = maximum_energy
