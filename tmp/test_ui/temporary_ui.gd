extends Control


func _on_button_pressed() -> void:
	Eventbus.new_upgrade.emit("Weapon000")


func _on_button_drill_pressed() -> void:
	Eventbus.new_upgrade.emit("Drill")
