extends CharacterBody3D
class_name Player

var speed: float = 10
const JUMP_VELOCITY = 4

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Global.player = self
	Global.picked_up.connect(_on_candy_picked_up)
	
func _on_candy_picked_up(type: GlobalEnums.CandyType, candy_node: Node3D) -> void:
	match type:
		GlobalEnums.CandyType.Shrink:
			speed *= 1.2
			$MeshInstance3D.mesh.radius -= 0.1
			$CollisionShape3D.shape.radius -= 0.1
		GlobalEnums.CandyType.Grow:
			speed /= 1.2
			$MeshInstance3D.mesh.radius += 0.1
			$CollisionShape3D.shape.radius += 0.1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	var input_dir: Vector2 = Input.get_vector("right", "left", "backward", "forward")
	var orientation: Basis = $Camera3D.transform.basis
	var direction: Vector3 = (orientation * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
