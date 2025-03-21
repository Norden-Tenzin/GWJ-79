extends Node3D

@export var next_lvl: GlobalEnums.SceneName

func _on_area_component_node_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Global.scene_manager.change_3d_scene(next_lvl)
