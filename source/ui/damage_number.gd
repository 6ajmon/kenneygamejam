extends Control
class_name DamageNumber

@onready var label: Label = $Label
@export var duration: float = 1.5
@export var move_distance: float = 50.0
@export var text_size: int = 24
@export var min_damage_for_red: float = 50.0
@export var max_size_multiplier: float = 2.0

func setup_damage(damage: float, world_position: Vector3) -> void:
	label.text = str(int(damage))
	
	var damage_ratio = clamp(damage / min_damage_for_red, 0.0, 1.0)
	var size_multiplier = lerp(1.0, max_size_multiplier, damage_ratio)
	var final_text_size = int(text_size * size_multiplier)
	label.add_theme_font_size_override("font_size", final_text_size)
	
	var color = Color.WHITE.lerp(Color.RED, damage_ratio)
	label.modulate = color
	
	var camera = get_viewport().get_camera_3d()
	if camera:
		var screen_pos = camera.unproject_position(world_position)
		position = screen_pos
	
	animate_damage_number()

func animate_damage_number() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "position:y", position.y - move_distance, duration)
	
	tween.tween_property(self, "modulate:a", 0.0, duration)
	
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3).set_delay(0.2)
	
	tween.tween_callback(queue_free).set_delay(duration)
