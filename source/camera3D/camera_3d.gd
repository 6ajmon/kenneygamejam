extends Camera3D

@export var target_path: NodePath  
var offset: Vector3 
@export var follow_speed: float = 20

var target: Node3D

func _ready():
	offset = position
	target = get_node(target_path)

func _physics_process(delta: float) -> void:
	if not target:
		return

	var target_position = target.global_transform.origin + offset
	global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)
