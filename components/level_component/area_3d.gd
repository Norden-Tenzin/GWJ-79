extends Area3D


func _on_body_entered(body: Node3D) -> void:
	Global.level_lost.emit()
	Global.scene_manager.reset_3d_scene()
