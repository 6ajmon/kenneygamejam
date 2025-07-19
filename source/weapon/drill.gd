extends Node3D
class_name DrillWeapon

@onready var drill_mesh = $drill_structure2/drill_module
@export var rotation_speed: float = 10.0
@export var tick_damage: float = 10.0
var total_rotation: float = 0
var can_deal_damage: bool = true

func _physics_process(delta: float) -> void:
	var rotation_angle = rotation_speed * delta
	drill_mesh.rotate(Vector3.FORWARD, rotation_angle)
	total_rotation += rotation_angle
	if (total_rotation >= 2 * PI):
		can_deal_damage = true

func increase_drill_size() -> void:
	scale += Vector3(0.25, 0.25, 0.25)
	position.z -= 1.4 * 0.25
	position.z *= 0.25

func get_damage() -> float:
	if (can_deal_damage):
		can_deal_damage = false
		return tick_damage
	else:
		return 0
