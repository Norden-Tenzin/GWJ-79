extends Node3D

func _on_area_component_node_entered(body: Node3D) -> void:
	var push_direction: Vector3 = -self.global_transform.basis.z.normalized()
	if body.is_in_group("Player"):
		if body is Player:
			body.add_effect(self.get_instance_id(), push_direction)

func _on_area_component_node_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body is Player:
			body.remove_effect(self.get_instance_id())
