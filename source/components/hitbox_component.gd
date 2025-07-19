extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent
@export var damage_groups: Array[String] = ["projectiles", "player", "contact_damage"]
@export var contact_damage_interval: float = 0.1

var contact_objects: Dictionary = {}
var damage_timer: Timer

func _ready():
	damage_timer = Timer.new()
	damage_timer.wait_time = contact_damage_interval
	damage_timer.timeout.connect(_apply_contact_damage)
	add_child(damage_timer)

func _on_area_entered(area: Area3D) -> void:
	_handle_collision_enter(area)

func _on_area_exited(area: Area3D) -> void:
	_handle_collision_exit(area)

func _on_body_entered(body: Node3D) -> void:
	_handle_collision_enter(body)

func _on_body_exited(body: Node3D) -> void:
	_handle_collision_exit(body)

func _handle_collision_enter(collider: Node3D) -> void:
	var should_damage = false
	for group in damage_groups:
		if collider.is_in_group(group):
			should_damage = true
			break
	
	if not should_damage:
		return
		
	if collider.is_in_group("projectiles"):
		_apply_immediate_damage(collider)
	else:
		contact_objects[collider] = true
		if contact_objects.size() == 1:
			damage_timer.start()

func _handle_collision_exit(collider: Node3D) -> void:
	if collider in contact_objects:
		contact_objects.erase(collider)
		if contact_objects.size() == 0:
			damage_timer.stop()

func _apply_immediate_damage(collider: Node3D) -> void:
	var damage_amount = _get_damage_amount(collider)
	if health_component and damage_amount > 0:
		health_component.take_damage(damage_amount)
		if collider.has_method("on_hit"):
			collider.on_hit()

func _apply_contact_damage() -> void:
	for collider in contact_objects.keys():
		if is_instance_valid(collider):
			var damage_amount = _get_damage_amount(collider)
			if health_component and damage_amount > 0:
				health_component.take_damage(damage_amount)
		else:
			contact_objects.erase(collider)

func _get_damage_amount(collider: Node3D) -> float:
	var damage_amount = 0.0
	if collider.has_method("get_damage"):
		damage_amount = collider.get_damage()
	elif collider.has_meta("damage"):
		damage_amount = collider.get_meta("damage")
	return damage_amount
