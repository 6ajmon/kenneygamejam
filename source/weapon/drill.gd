extends Node3D
class_name DrillWeapon

@onready var drill_mesh = $drill_structure2/drill_module
@export var rotation_speed: float = 16.0
@export var tick_damage: float = 15.0
var total_rotation: float = 0
var can_deal_damage: bool = true

func _ready() -> void:
	if GameData.StatBoosts.damage != 0:
		tick_damage *= GameData.StatBoosts.damage

func _physics_process(delta: float) -> void:
	var rotation_angle = rotation_speed * delta
	drill_mesh.rotate(Vector3.FORWARD, rotation_angle)
	total_rotation += rotation_angle
	if (total_rotation >= TAU):
		total_rotation = fmod(total_rotation, TAU)
		can_deal_damage = true

func increase_drill_size() -> void:
	var increase_value = 0.25
	scale += Vector3(increase_value, increase_value, increase_value)
	position.z -= 1.4 * increase_value
	position.z *= increase_value
	rotation_speed += rotation_speed * increase_value

func get_damage() -> float:
	if (can_deal_damage):
		can_deal_damage = false
		return tick_damage
	else:
		return 0
