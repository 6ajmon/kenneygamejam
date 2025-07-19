extends CharacterBody3D
class_name PlayerVehicle

@export var max_speed: float = 30.0
@export var acceleration: float = 5.0
@export var deceleration: float = 8.0
@export var turn_speed: float = 2.0  
@export var backward_penalty: float = 0.6
@export var turning_penalty : float = 0
@export var backward_max_speed: float = 18
@export var camera: PlayerCamera

var current_speed: float = 0.0
var strafe := 0.0
var previous_rotation_y: float = 0.0
var previous_position: Vector3 = Vector3.ZERO

@onready var spotlight: SpotLight3D = $Beam/SpotLight3D
@onready var weapon_slots_node: Node3D = $WeaponSlotsNode
var weapon_slots = []
var drill_slot


func _ready() -> void:
	GameData.PlayerPosition = global_position
	Eventbus.connect("new_upgrade", get_new_upgrade)
	weapon_slots = weapon_slots_node.get_children()
	drill_slot = $DrillSlot
	
func _physics_process(delta: float) -> void:
	if global_position.distance_to(previous_position) > 0.01:
		GameData.PlayerPosition = global_position
		previous_position = global_position

	move_and_rotate(delta)
	if Input.is_action_pressed("left_click"):
		shoot()

func move_and_rotate(delta: float) -> void:
	
	var is_strafing = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		
	if Input.is_action_pressed("move_forward"):
		current_speed += acceleration * delta
	elif Input.is_action_pressed("move_backward"):
		if current_speed <= 0:
			current_speed -= acceleration * delta * backward_penalty
		else:
			current_speed -= acceleration * delta
	else:
		current_speed = move_toward(current_speed, 0.0, deceleration * delta)
	
	if !is_strafing:
		current_speed = clamp(current_speed, -backward_max_speed, max_speed)
	else:
		current_speed = clamp(current_speed, -backward_max_speed, backward_max_speed)
	
	if Input.is_action_pressed("move_left"):
		strafe -= acceleration * delta * backward_penalty
	elif Input.is_action_pressed("move_right"):
		strafe += acceleration * delta * backward_penalty
	else:
		strafe = move_toward(strafe, 0, deceleration * delta)
	
	strafe = clamp(strafe, -backward_max_speed, backward_max_speed)
	
	var direction := _get_mouse_direction()
	
	if direction.length() > 0.01:
		var target_angle := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
		var angle_change = abs(rotation.y - previous_rotation_y)
		previous_rotation_y = rotation.y

		var steering_penalty: float = angle_change * turning_penalty
		current_speed = move_toward(current_speed, 0.0, steering_penalty)

	
	var forward_direction = -transform.basis.z.normalized()
	var right_direction = transform.basis.x.normalized()


	
	velocity = forward_direction * current_speed + right_direction * strafe 
	move_and_slide()

func shoot() -> void:
	for slot : WeaponSpot in weapon_slots:
		if slot.is_taken():
			var vehicle_speed = current_speed
			if current_speed < 0:
				vehicle_speed = 0
			slot.weapon.shoot(vehicle_speed)

func get_new_upgrade(upgrade_name: String) -> void:
	var new_upgrade_scene : PackedScene = GameData.Upgrades[upgrade_name].scene
	var new_upgrade = new_upgrade_scene.instantiate()
	if new_upgrade is Weapon:
		for slot : WeaponSpot in weapon_slots:
			if !slot.is_taken():
				slot.add_child(new_upgrade)
				slot.weapon = new_upgrade
				return
	elif new_upgrade is DrillWeapon:
			if !drill_slot.is_taken():
				drill_slot.add_child(new_upgrade)
				drill_slot.weapon = new_upgrade
				return




func _get_mouse_direction() -> Vector3:
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)

	var plane_y := global_transform.origin.y
	var distance := (plane_y - ray_origin.y) / ray_dir.y
	var target_pos := ray_origin + ray_dir * distance
	
	var direction := (target_pos - global_transform.origin)
	direction.y = 0 
	direction = direction.normalized()
	
	return direction
