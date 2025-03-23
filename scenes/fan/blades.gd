extends MeshInstance3D

func _phsysics() -> void:
	rotate_object_local(transform.basis.x, 1)
