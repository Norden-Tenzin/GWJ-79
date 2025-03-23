extends StaticBody3D

func _on_plate_state_changed(plate_id: int, plate_state: bool) -> void:
	queue_free()
