extends Turret

func _ready() -> void:
	damage = 5.0
	shots_per_second = 8.0
	detection_range = 10.0
	bullet_speed = 25.0
	rotation_speed = 8.0
	pierce = 1
	
	super._ready()
