extends Node3D

@onready var shape_cast_3d: ShapeCast3D = %Wind
@export var push_force: float
@export var min_distance: float

func _process(_delta: float) -> void:
	if shape_cast_3d.is_colliding():
		for i in range(shape_cast_3d.get_collision_count()):
			var collider: Object = shape_cast_3d.get_collider(i)
			if collider is CharacterBody3D and collider.is_in_group("Player"):
				push_player(collider)

func push_player(player: CharacterBody3D) -> void:
	var push_direction: Vector3 = (global_transform.basis.z.normalized())
	var direction_to_player: Vector3 = player.global_transform.origin - global_transform.origin
	var distance_to_player: float = direction_to_player.length()
	print(distance_to_player)
	if distance_to_player <= min_distance:
		player.velocity += push_direction * push_force * 2
	else:
		player.velocity += push_direction * push_force
	player.move_and_slide()
