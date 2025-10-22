extends Area3D

#Is this weakspot destroyed?
var hit: bool = false

signal weakspot_destroyed

func _process(delta: float) -> void:
	if has_overlapping_bodies():
		check_hit(get_overlapping_bodies())

func check_hit(bodies: Array):
	for body in bodies:
			if body.is_in_group("Player"):
				weakspot_destroyed.emit()
				queue_free()
