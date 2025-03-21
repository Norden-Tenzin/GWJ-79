extends Area3D

signal level_lost

func _on_body_entered(body: Node3D) -> void:
	level_lost.emit()
