@tool
extends Node3D

@export var candy_stat: CandyStats
@onready var mesh_instance: MeshInstance3D = %Mesh

func _ready() -> void: 
	if candy_stat:
		mesh_instance.mesh = candy_stat.mesh
		mesh_instance.material_overlay = candy_stat.material

func _on_area_component_player_entered() -> void:
	Global.picked_up.emit(candy_stat.type, candy_stat.growth_amount, candy_stat.jump_velocity_change, self)
	queue_free()
