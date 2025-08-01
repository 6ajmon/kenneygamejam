extends Camera3D
class_name PlayerCamera

@export var target: PlayerVehicle  
var offset: Vector3 
@export var follow_speed: float = 20.0
@export var distance_from_player: float = 12.0


func _ready():
	position.y += distance_from_player
	offset = position

func _physics_process(delta: float) -> void:
	if not target:
		return

	var target_position = target.global_transform.origin + offset
	global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)
