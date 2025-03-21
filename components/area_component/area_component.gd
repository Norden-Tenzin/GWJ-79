extends Area3D

signal node_entered(body: Node3D)
signal node_exited(body: Node3D)

# checks if body is Player if yes signal
func _on_body_entered(body: Node3D) -> void:
	node_entered.emit(body)

func _on_body_exited(body: Node3D) -> void:
	node_exited.emit(body)
