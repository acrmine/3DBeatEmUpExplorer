extends Node3D

#Is this weakspot destroyed?
var hit: bool = false

@onready var area = $Area3D

signal weakspot_destroyed

func _process(delta: float) -> void:
	if area.has_overlapping_bodies():
		check_hit(area.get_overlapping_bodies())

func check_hit(bodies: Array):
	for body in bodies:
			if body.is_in_group("Player"):
				weakspot_destroyed.emit()
				queue_free()
