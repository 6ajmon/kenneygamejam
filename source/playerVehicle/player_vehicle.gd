extends CharacterBody3D
class_name PlayerVehicle

@export var camera: PlayerCamera
@export var contact_damage: float = 10
@export var velocity_damage_multiplier: float = 0.06
@export var contact_slowdown_factor: float = 0.6

@export var max_energy:float = 100
@export var current_energy_usage:float = 1

var previous_position: Vector3 = Vector3.ZERO
var can_deal_damage: bool = true

@onready var spotlight: SpotLight3D = $Beam/SpotLight3D
@onready var power_system = $PowerSystem
@onready var movement: Node3D = $Movement

@onready var weapon_slots_node: Node3D = $WeaponSlotsNode
@onready var turret_slots_node: Node3D = $TurretSlots
var weapon_slots = []
var drill_slot
var turret_slots = []

var contact_damage_timer: Timer
var energy_consumption_timer: Timer

func _ready() -> void:
	GameData.PlayerPosition = global_position
	GameData.PlayerRotation = rotation.y
	weapon_slots = weapon_slots_node.get_children().filter(func(child): return child is WeaponSlot)
	drill_slot = $DrillSlot
	turret_slots = turret_slots_node.get_children().filter(func(child): return child is WeaponSlot)
	
	max_energy += GameData.statBoosts.max_power
	power_system.maximum_energy = max_energy
	power_system.initialize_power_system()
	print(drill_slot.is_taken())
	
	contact_damage_timer = Timer.new()
	contact_damage_timer.wait_time = 1.0
	contact_damage_timer.one_shot = true
	contact_damage_timer.timeout.connect(_reset_damage_ability)
	add_child(contact_damage_timer)
	
	energy_consumption_timer = Timer.new()
	energy_consumption_timer.wait_time = 1.0
	energy_consumption_timer.one_shot = false
	energy_consumption_timer.timeout.connect(_consume_energy)
	add_child(energy_consumption_timer)
	energy_consumption_timer.start()

	if GameData.statBoosts.damage != 0:
		contact_damage *= GameData.statBoosts.damage
	
	load_upgrades()

func _physics_process(delta: float) -> void:
	if global_position.distance_to(previous_position) > 0.01:
		GameData.PlayerPosition = global_position
		GameData.PlayerRotation = rotation.y
		previous_position = global_position

	movement.move_and_rotate(delta)
	if Input.is_action_pressed("left_click"):
		shoot()
	
	AudioManager.emit_signal("player_vehicle")

func shoot() -> void:
	for slot : WeaponSlot in weapon_slots:
		if slot.is_taken():
			var vehicle_speed = movement.get_current_speed()
			if vehicle_speed < 0:
				vehicle_speed = 0
			slot.weapon.shoot(vehicle_speed)

func load_upgrades() -> void:
	for upgrade : Upgrade in GameData.UpgradesUnlocked:
		if upgrade.type == GameData.upgradeTypes.Weapon:
			for slot : WeaponSlot in weapon_slots:
				if !slot.is_taken():
					var new_weapon = upgrade.scene.instantiate()
					slot.add_child(new_weapon)
					slot.weapon = new_weapon
					break
		if upgrade.type == GameData.upgradeTypes.DrillWeapon:
			if !drill_slot.is_taken():
				var new_drill = upgrade.scene.instantiate()
				drill_slot.add_child(new_drill)
				drill_slot.weapon = new_drill
			else:
				drill_slot.get_child(0).increase_drill_size()
		if upgrade.type == GameData.upgradeTypes.Turret:
			for slot : WeaponSlot in turret_slots:
				if !slot.is_taken():
					var new_turret = upgrade.scene.instantiate()
					slot.add_child(new_turret)
					slot.weapon = new_turret
					break

func get_damage() -> float:
	if can_deal_damage:
		can_deal_damage = false
		contact_damage_timer.start()
		
		var current_velocity = velocity.length()
		var velocity_multiplier = 1.0 + (current_velocity * velocity_damage_multiplier)
		var damage = contact_damage * velocity_multiplier
		
		movement.current_speed *= (1.0 - contact_slowdown_factor)
		movement.strafe *= (1.0 - contact_slowdown_factor)
		
		return damage
	else:
		return 0

func _reset_damage_ability() -> void:
	can_deal_damage = true

func _consume_energy() -> void:
	if power_system:
		var energy_drain = current_energy_usage + GameData.statBoosts.power_usage + (0.6 * (GameData.CurrentRound - 1))
		power_system.change_energy(-energy_drain)
