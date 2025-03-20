extends Marker3D

signal spawn(pos: Vector3)

@export var character_name: String

func _ready() -> void:
	%Visualizer.queue_free()
	if owner.has_node(character_name):
		var chara_node: CharacterBody3D = owner.get_node(character_name)
		chara_node.position = self.global_position
