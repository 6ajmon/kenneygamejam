extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent
@export var damage_groups: Array[String] = ["projectiles", "player"]

func _ready() -> void:
	if not health_component:
		health_component = get_parent().get_node("HealthComponent")
	

func _on_area_entered(area: Area3D) -> void:
	_handle_collision(area)

func _on_body_entered(body: Node3D) -> void:
	_handle_collision(body)

func _handle_collision(collider: Node3D) -> void:
	var should_damage = false
	for group in damage_groups:
		if collider.is_in_group(group):
			should_damage = true
			break
	
	if not should_damage:
		return
	var damage_amount = 0.0
	if collider.has_method("get_damage"):
		damage_amount = collider.get_damage()
	elif collider.has_meta("damage"):
		damage_amount = collider.get_meta("damage")
	
	if health_component and damage_amount > 0:
		health_component.take_damage(damage_amount)
		
		if collider.has_method("on_hit"):
			collider.on_hit()
