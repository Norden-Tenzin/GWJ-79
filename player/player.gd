extends CharacterBody3D
class_name Player

var speed: float = 5
var jump_velocity: float = 3

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Global.player = self
	Global.picked_up.connect(_on_candy_picked_up)
	Global.level_lost.connect(_on_level_lost)
	
func _on_level_lost() -> void:
	# we should reload the level here idk
	print("you lost")
	
func _on_candy_picked_up(type: GlobalEnums.CandyType, growth_amount: float, jump_velocity_change: float, candy_node: Node3D) -> void:
	match type:
		GlobalEnums.CandyType.Shrink:
			pass
			#$MeshInstance3D.mesh.bottom_radius -= abs(growth_amount)
			#$MeshInstance3D.mesh.top_radius -= abs(growth_amount)
			#$CollisionShape3D.shape.radius -= abs(growth_amount)
			#jump_velocity -= abs(jump_velocity_change)
			
		GlobalEnums.CandyType.Grow:
			pass
			#$MeshInstance3D.mesh.bottom_radius += abs(growth_amount)
			#$MeshInstance3D.mesh.top_radius += abs(growth_amount)
			#$CollisionShape3D.shape.radius += abs(growth_amount)
			#jump_velocity += abs(jump_velocity_change)
			
var root_velocity: Vector3
			
func _process(delta: float) -> void:
	var root_pos: Vector3 = $AnimationTree.get_root_motion_position()
	var current_rotation: Quaternion = ($AnimationTree.get_root_motion_rotation_accumulator().inverse() * get_quaternion())
	root_velocity = current_rotation * root_pos / delta
	var root_rotation: Quaternion = $AnimationTree.get_root_motion_rotation()
	set_quaternion(get_quaternion() * root_rotation)

var last_move_direction: Vector3 = Vector3.FORWARD

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "backward", "forward")
	var direction: Vector3 = ($Camera3D.direction.x * input_dir.x) + ($Camera3D.direction.z * input_dir.y)
	direction.y = 0.0
	direction = direction.normalized()
	if input_dir.length() > 0:
		$AnimationTree.get("parameters/playback").travel("Slow Run")
		last_move_direction = direction
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationTree.get("parameters/playback").travel("Running Jump")

	var target_basis: Basis = Basis().looking_at(-last_move_direction, Vector3.UP)
	var current_basis: Basis = $kid.global_transform.basis
	var smoothed_basis: Basis = current_basis.slerp(target_basis, 0.1)

	var new_transform: Transform3D = $kid.global_transform
	new_transform.basis = smoothed_basis
	$kid.global_transform = new_transform
	velocity = root_velocity.length() * direction

	if not is_on_floor():
		velocity.y -= gravity

	move_and_slide()
