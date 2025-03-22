extends Node3D

enum TransitionType {
	Fade,
	Candy
}

@export var next_lvl: GlobalEnums.SceneName
@export var transition_type: TransitionType

func _on_area_component_node_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		match transition_type:
			TransitionType.Fade: Global.scene_manager.change_3d_scene(
				next_lvl,
				true,
				false,
				true,
				"fade_in",
				"fade_out",
				1.0
			)
			TransitionType.Candy: Global.scene_manager.change_3d_scene(
				next_lvl,
				true,
				false,
				true,
				"candy_in",
				"candy_out",
				1.0
			)
