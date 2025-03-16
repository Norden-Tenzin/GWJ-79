@tool
extends Node3D

signal picked_up(type: GlobalEnums.CandyType, candy_node: Node3D)

@export var candy_stat: CandyStats
@onready var mesh_instance: MeshInstance3D = %Mesh

func _ready() -> void: 
	if candy_stat:
		mesh_instance.mesh = candy_stat.mesh
		mesh_instance.material_overlay = candy_stat.material

func _on_area_component_player_entered() -> void:
	picked_up.emit(candy_stat.type, self)
