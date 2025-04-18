@tool
extends Node3D

signal candy_picked_up(candy_type: GlobalEnums.CandyType)

@export var candy_stat: CandyStats
@onready var mesh_instance: MeshInstance3D = %Mesh

func _ready() -> void: 
	if candy_stat:
		mesh_instance.mesh = candy_stat.mesh
		mesh_instance.material_override = candy_stat.material
		mesh_instance.material_overlay = candy_stat.material_overlay

func _on_area_component_node_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		candy_picked_up.emit(candy_stat.type)
		queue_free()
