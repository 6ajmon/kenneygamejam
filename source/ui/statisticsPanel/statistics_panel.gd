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

func _ready() -> void:
	update_statistics()

func update_statistics() -> void:
	if GameData.statBoosts == null:
		return
		
	damage_value_label.text = str(GameData.statBoosts.damage)
	bullets_per_second_value_label.text = str(GameData.statBoosts.bullets_per_second)
	pierce_value_label.text = str(GameData.statBoosts.pierce)
	power_capacity_value_label.text = str(GameData.statBoosts.max_power)
	power_usage_value_label.text = str(GameData.statBoosts.power_usage)
	top_speed_value_label.text = str(GameData.statBoosts.max_speed)
	acceleration_value_label.text = str(GameData.statBoosts.acceleration)
	bullet_size_value_label.text = str(GameData.statBoosts.bullet_size)
