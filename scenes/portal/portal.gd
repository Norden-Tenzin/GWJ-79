extends Node3D

@export var next_lvl: GlobalEnums.SceneName

func _on_area_component_player_entered() -> void:
	Global.scene_manager.change_3d_scene(next_lvl)
