extends Area3D

signal player_entered

# checks if body is Player if yes signal
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_entered.emit()
