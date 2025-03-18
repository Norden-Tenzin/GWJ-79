extends Resource
class_name CandyStats

@export var type: GlobalEnums.CandyType
@export var mesh: Mesh
@export var material: StandardMaterial3D
## Change in the player's radius
@export var growth_amount: float
## Change in the player's speed (default: 10)
@export var speed_change: float
