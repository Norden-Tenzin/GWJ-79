extends CharacterBody3D
class_name Player

@onready var debug_label: Label3D = %DebugLabel
@export var jump_velocity: int = 4
@export var player_state: GlobalEnums.PlayerState = GlobalEnums.PlayerState.Normal

# TODO: pick wind_force
@export var wind_force: float = 5

enum AnimationState
{Pushing, Pushing_pose, Slow_Run, Idle}

var last_move_direction: Vector3 = Vector3.FORWARD
var effects: Dictionary[int, Vector3] = {}
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var root_velocity: Vector3
var current_animation: AnimationState = AnimationState.Idle
var direction: Vector3

func _ready() -> void:
	Global.player = self
	owner.connect("eat_candy", _eat_candy)

func _process(delta: float) -> void:
	var root_pos: Vector3 = $AnimationTree.get_root_motion_position()
	var current_rotation: Quaternion = ($AnimationTree.get_root_motion_rotation_accumulator().inverse() * get_quaternion())
	root_velocity = current_rotation * root_pos / delta
	var root_rotation: Quaternion = $AnimationTree.get_root_motion_rotation()
	set_quaternion(get_quaternion() * root_rotation)

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "backward", "forward")
	if Input.is_action_just_pressed("ready to push box") && current_animation != AnimationState.Pushing_pose && current_animation != AnimationState.Pushing && $AnimationTree.get("parameters/conditions/near box"):
		var point: Node3D = get_closest_node_on_body($ShapeCast3D.box)
		global_position.x = point.global_position.x
		global_position.z = point.global_position.z
		var look_at_dir: Vector3
		look_at_dir.x = point.transform.basis.z.x
		look_at_dir.z = point.transform.basis.z.z
		look_at_dir = look_at_dir.normalized()
		last_move_direction = look_at_dir
		direction = look_at_dir
		$AnimationTree.get("parameters/playback").travel("Pushing pose")
		current_animation = AnimationState.Pushing_pose
	elif Input.is_action_just_pressed("ready to push box") && (current_animation == AnimationState.Pushing || current_animation == AnimationState.Pushing_pose):
		$AnimationTree.get("parameters/playback").travel("Idle")
		current_animation = AnimationState.Idle
	elif current_animation != AnimationState.Pushing_pose && current_animation != AnimationState.Pushing:
		direction = ($Camera3D.direction.x * input_dir.x) + ($Camera3D.direction.z * input_dir.y)
		direction.y = 0.0
		direction = direction.normalized()
		
		
	if input_dir.length() > 0:
		if current_animation == AnimationState.Pushing_pose:
			$AnimationTree.get("parameters/playback").travel("Pushing")
			current_animation = AnimationState.Pushing
		elif current_animation == AnimationState.Idle || current_animation == AnimationState.Slow_Run:
			$AnimationTree.get("parameters/playback").travel("Slow Run")
			current_animation = AnimationState.Slow_Run
			last_move_direction = direction
	else:
		if current_animation == AnimationState.Pushing:
			$AnimationTree.get("parameters/playback").travel("Pushing pose")
			current_animation = AnimationState.Pushing_pose
		elif current_animation == AnimationState.Slow_Run:
			$AnimationTree.get("parameters/playback").travel("Idle")
			current_animation = AnimationState.Idle
	
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
	wind_effect()
	push_away_rigid_bodies()
	move_and_slide()

# Pushing Boxes functionality
func push_away_rigid_bodies() -> void:
	if current_animation != AnimationState.Pushing && current_animation != AnimationState.Pushing_pose:
		return
	for i in get_slide_collision_count():
		var collision_obj: KinematicCollision3D = get_slide_collision(i)
		if collision_obj.get_collider() is RigidBody3D:
			var push_direction: Vector3 = -collision_obj.get_normal()
			
			push_direction = Vector3.ZERO
			var collision_normal: Vector3 = collision_obj.get_normal()
			# Find the axis with the largest absolute component of the normal
			if abs(collision_normal.x) > abs(collision_normal.z):
				push_direction.x = -sign(collision_normal.x)
			else:
				push_direction.z = -sign(collision_normal.z)
			var velocity_diff_in_push_dir: float = self.velocity.dot(push_direction) - collision_obj.get_collider().linear_velocity.dot(push_direction)
			
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push
			const MY_APPROX_MASS_KG: float = 80.0
			var mass_ratio: float = min(1., MY_APPROX_MASS_KG / collision_obj.get_collider().mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_direction.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force: float = mass_ratio * 5.0
			
			# Lock rotation before applying impulse
			collision_obj.get_collider().lock_rotation = true
			
			# Apply central impulse instead of offset impulse
			collision_obj.get_collider().apply_central_impulse(
				push_direction * velocity_diff_in_push_dir * push_force
			)

# Wind Effect functionality
func wind_effect() -> void:
	var final_push_direction: Vector3
	for id in effects:
		var push_direction: Vector3 = effects[id]
		final_push_direction = (final_push_direction + push_direction).normalized()
	# TODO: pick a push_force
	match player_state:
		GlobalEnums.PlayerState.Small:
			velocity += final_push_direction * wind_force
		GlobalEnums.PlayerState.Normal:
			velocity += final_push_direction * wind_force
		GlobalEnums.PlayerState.Big:
			velocity += final_push_direction * wind_force

func get_closest_node_on_body(body: RigidBody3D) -> Node3D:
	var closest_node: Node3D = null
	var closest_distance: float = INF
	var player_pos: Vector3 = global_transform.origin
	for child in body.get_children():
		if child is Node3D:
			var child_pos: Vector3 = child.global_transform.origin
			var dist: float = player_pos.distance_to(child_pos)
			if dist < closest_distance:
				closest_distance = dist
				closest_node = child
	return closest_node

# on candy pickup
func _eat_candy(candy_type: GlobalEnums.CandyType) -> void:
	match player_state:
		GlobalEnums.PlayerState.Small:
			match candy_type:
				GlobalEnums.CandyType.Grow:
					player_state = GlobalEnums.PlayerState.Normal
		GlobalEnums.PlayerState.Normal:
			match candy_type:
				GlobalEnums.CandyType.Grow:
					player_state = GlobalEnums.PlayerState.Big
				GlobalEnums.CandyType.Shrink:
					player_state = GlobalEnums.PlayerState.Small
		GlobalEnums.PlayerState.Big:
			match candy_type:
				GlobalEnums.CandyType.Shrink:
					player_state = GlobalEnums.PlayerState.Normal
	update_state()

func update_state() -> void:
	match player_state:
		GlobalEnums.PlayerState.Small:
			debug_label.text = "Small"
		GlobalEnums.PlayerState.Normal:
			debug_label.text = "Normal"
		GlobalEnums.PlayerState.Big:
			debug_label.text = "Big"

# wind effect funcs
func add_effect(fan_id: int, push_direction: Vector3) -> void:
	effects.set(fan_id, push_direction)

func remove_effect(fan_id: int) -> void:
	effects.erase(fan_id)

func _on_level_lost() -> void:
	# we should reload the level here idk
	print("you lost")
