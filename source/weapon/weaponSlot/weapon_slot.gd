extends Marker3D
class_name WeaponSpot

var weapon : Node3D

func is_taken() -> bool:
	if weapon:
		return true
	return false
