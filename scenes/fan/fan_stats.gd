extends Resource
class_name FanStats

@export var shape_len: float
@export var enabled: bool
@export var push_force: float = 10.0
@export var max_distance: float = 5.0  # Max distance for full force
@export var shape: BoxShape3D
