extends Area3D

func _on_body_entered(body: Node3D) -> void:
	$"../AnimationPlayer".play("Open")

func _on_body_exited(body: Node3D) -> void:
	$"../AnimationPlayer".play_backwards("Open")
