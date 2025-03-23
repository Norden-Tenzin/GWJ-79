extends Node3D

@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/StaticBody3D/CollisionShape3D

func _on_area_component_node_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		match Global.player.player_state:
			GlobalEnums.PlayerState.Small:
				collision_shape_3d.disabled = true
			GlobalEnums.PlayerState.Normal:
				collision_shape_3d.disabled = true
			GlobalEnums.PlayerState.Big:
				pass

func _on_area_component_node_exited(body: Node3D) -> void:
	collision_shape_3d.disabled = false
