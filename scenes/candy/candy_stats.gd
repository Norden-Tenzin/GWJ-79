extends Resource
class_name CandyStats

@export var type: GlobalEnums.CandyType
@export var mesh: Mesh
@export var material: StandardMaterial3D
## Change in the player's radius
@export var growth_amount: float
## Change in how high the player can jump, Default is 3
@export var jump_velocity_change: float
