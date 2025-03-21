extends Area3D

signal player_entered(body: Node3D)
signal player_exited(body: Node3D)

# checks if body is Player if yes signal
func _on_body_entered(body: Node3D) -> void:
	player_entered.emit(body)

func _on_body_exited(body: Node3D) -> void:
	player_exited.emit(body)
