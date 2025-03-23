extends MeshInstance3D

@export var degrees_per_second: float = 15
@export var hovers_per_second: float = 3

@onready var origin: Vector3 = position
var total_time: float = 0.0

func _process(delta: float) -> void:
	total_time += delta
	
	position.y = origin.y + ((cos(total_time * hovers_per_second)/2)+1) * 0.25
	rotate_y(deg_to_rad(degrees_per_second * delta))
