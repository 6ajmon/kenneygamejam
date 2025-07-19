extends Node3D
class_name DamageNumberDisplayComponent

@export var damage_number_scene: PackedScene
@export var offset_range: Vector3 = Vector3(1, 1, 0)

func show_damage(damage: float, number_position: Vector3) -> void:
	if damage_number_scene == null:
		return
		
	var damage_number = damage_number_scene.instantiate()
	get_tree().current_scene.add_child(damage_number)
	
	var random_offset = Vector3(
		randf_range(-offset_range.x, offset_range.x),
		randf_range(-offset_range.y, offset_range.y),
		randf_range(-offset_range.z, offset_range.z)
	)
	
	damage_number.setup_damage(damage, number_position + random_offset)
