extends CharacterBody3D


func _on_weak_spot_weakspot_destroyed() -> void:
	get_parent().queue_free()
