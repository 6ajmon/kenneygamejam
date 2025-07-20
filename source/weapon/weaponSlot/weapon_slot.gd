extends Marker3D
class_name WeaponSlot

var weapon : Node3D

func is_taken() -> bool:
	if weapon:
		return true
	return false
