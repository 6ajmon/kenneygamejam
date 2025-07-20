extends Turret

func _ready() -> void:
	damage = 20.0
	shots_per_second = 1.0
	detection_range = 10.0
	bullet_speed = 40.0
	rotation_speed = 10.0
	pierce = 2
	
	super._ready()
