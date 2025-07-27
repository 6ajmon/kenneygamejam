extends Panel

@onready var statistics_list: Control = $StatisticsMarginContainer/StatisticsScrollContainer/StatisticsList
@onready var damage_value_label: Label = statistics_list.get_node("Damage/Value")
@onready var bullets_per_second_value_label: Label = statistics_list.get_node("BulletsPerSecond/Value")
@onready var pierce_value_label: Label = statistics_list.get_node("Pierce/Value")
@onready var power_capacity_value_label: Label = statistics_list.get_node("PowerCapacity/Value")
@onready var power_usage_value_label: Label = statistics_list.get_node("PowerUsage/Value")
@onready var top_speed_value_label: Label = statistics_list.get_node("TopSpeed/Value")
@onready var acceleration_value_label: Label = statistics_list.get_node("Acceleration/Value")
@onready var bullet_size_value_label: Label = statistics_list.get_node("BulletSize/Value")
@onready var bullet_range_value_label: Label = statistics_list.get_node("BulletRange/Value")

@onready var guns_value_label: Label = statistics_list.get_node("Guns/Value")
@onready var turrets_value_label: Label = statistics_list.get_node("Turrets/Value")
@onready var special_weapons_value_label: Label = statistics_list.get_node("SpecialWeapons/Value")

@onready var highest_damage_dealt_value_label: Label = statistics_list.get_node("HighestDamageDealt/Value")
@onready var total_kills_value_label: Label = statistics_list.get_node("TotalKills/Value")
@onready var total_souls_collected_value_label: Label = statistics_list.get_node("TotalSoulsCollected/Value")
@onready var total_damage_dealt_value_label: Label = statistics_list.get_node("TotalDamageDealt/Value")

const MULT = "×"
const ADD = "+"
const SUB = "-"
const OUT_OF = "/"
var stat: StatBoost = GameData.statBoosts

func _ready() -> void:
	update_statistics()
	Eventbus.item_purchased.connect(update_statistics)
	
func update_statistics(_upgrade_name: String = "", _upgrade: Upgrade = null) -> void:
	if stat == null:
		return
		
	damage_value_label.text = MULT + str(stat.damage)
	bullets_per_second_value_label.text = MULT + str(stat.bullets_per_second)
	pierce_value_label.text = get_number_sign(stat.pierce) + str(abs(stat.pierce))
	power_capacity_value_label.text = get_number_sign(stat.max_power) + str(abs(stat.max_power))
	power_usage_value_label.text = get_number_sign(stat.power_usage) + str(abs(stat.power_usage))
	top_speed_value_label.text = get_number_sign(stat.max_speed) + str(abs(stat.max_speed))
	acceleration_value_label.text = get_number_sign(stat.acceleration) + str(abs(stat.acceleration))
	bullet_range_value_label.text = get_number_sign(stat.bullet_range) + str(abs(stat.bullet_range))
	bullet_size_value_label.text = MULT + str(stat.bullet_size)

	guns_value_label.text = str(GameData.gunsEquipped) + OUT_OF + str(GameData.MAX_GUNS) 
	turrets_value_label.text = str(GameData.turretsEquipped) + OUT_OF + str(GameData.MAX_TURRETS)
	special_weapons_value_label.text = str(GameData.specialWeaponsEquipped) + OUT_OF + str(GameData.MAX_SPECIAL_WEAPONS)

	highest_damage_dealt_value_label.text = str(int(ceil(GameData.highestDamageDealt)))
	total_kills_value_label.text = str(GameData.totalKills)
	total_souls_collected_value_label.text = str(int(GameData.totalSoulsCollected))
	total_damage_dealt_value_label.text = str(int(GameData.totalDamageDealt))

func get_number_sign(value: float) -> String:
	if value < 0:
		return SUB
	else:
		return ADD
