extends AnimatableBody3D

@export var speed: float = 5
@export var pierce: int = 1
@export var damage: float = 10.0
var direction: Vector3 = Vector3.FORWARD

func _ready() -> void:
	pierce += GameData.statBoosts.pierce
	scale *= GameData.statBoosts.bullet_size
	
func _physics_process(delta: float) -> void:
	if !visible:
		visible = true

	translate(direction * speed * delta)


func _on_area_entered(_area):
	queue_free()

func get_damage() -> float:
	pierce -= 1
	if pierce <= 0:
		_on_queue_free_timer_timeout()
	var damage_boost = 1
	if GameData.statBoosts.damage != 0:
		damage_boost *= GameData.statBoosts.damage
	return damage * damage_boost


func _on_queue_free_timer_timeout() -> void:
	queue_free()
