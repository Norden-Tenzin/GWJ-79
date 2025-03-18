extends CharacterBody3D
class_name Player

var speed: float = 10
const JUMP_VELOCITY = 4

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Global.player = self
	Global.picked_up.connect(_on_candy_picked_up)
	Global.level_lost.connect(_on_level_lost)
	
func _on_level_lost() -> void:
	# we should reload the level here idk
	print("you lost")
	
func _on_candy_picked_up(type: GlobalEnums.CandyType, growth_amount: float, speed_change: float, candy_node: Node3D) -> void:
	match type:
		GlobalEnums.CandyType.Shrink:
			speed -= abs(speed_change)
			
			$MeshInstance3D.mesh.bottom_radius -= abs(growth_amount)
			$MeshInstance3D.mesh.top_radius -= abs(growth_amount)
			$CollisionShape3D.shape.radius -= abs(growth_amount)
			
		GlobalEnums.CandyType.Grow:
			speed += abs(speed_change)
			
			$MeshInstance3D.mesh.bottom_radius += abs(growth_amount)
			$MeshInstance3D.mesh.top_radius += abs(growth_amount)
			$CollisionShape3D.shape.radius += abs(growth_amount)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir: Vector2 = Input.get_vector("left", "right", "backward", "forward")
	
	var direction: Vector3 = ($Camera3D.direction.x * input_dir.x) + ($Camera3D.direction.z * input_dir.y)
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
