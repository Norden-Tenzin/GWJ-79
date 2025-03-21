extends CharacterBody3D
class_name Player

@onready var debug_label: Label3D = %DebugLabel

@export var speed: float = 10
@export var jump_velocity: int = 4
@export var player_state: GlobalEnums.PlayerState = GlobalEnums.PlayerState.Normal

# TODO: pick wind_force
@export var wind_force: float = 5.0

var effects: Dictionary[int, Vector3] = {}
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Global.player = self
	update_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	var input_dir: Vector2 = Input.get_vector("left", "right", "backward", "forward")
	var direction: Vector3 = ($Camera3D.direction.x * input_dir.x) + ($Camera3D.direction.z * input_dir.y)
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	wind_effect()
	push_away_rigid_bodies()
	move_and_slide()

# Pushing Boxes functionality
func push_away_rigid_bodies() -> void:
	for i in get_slide_collision_count():
		var collision_obj: KinematicCollision3D = get_slide_collision(i)
		if collision_obj.get_collider() is RigidBody3D:
			var push_direction: Vector3 = -collision_obj.get_normal()
			var velocity_diff_in_push_dir: float = self.velocity.dot(push_direction) - collision_obj.get_collider().linear_velocity.dot(push_direction)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			const MY_APPROX_MASS_KG: float = 80.0
			var mass_ratio: float = min(1., MY_APPROX_MASS_KG / collision_obj.get_collider().mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_direction.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force: float = mass_ratio * 5.0
			collision_obj.get_collider().apply_impulse(
				push_direction* velocity_diff_in_push_dir * push_force, 
				collision_obj.get_position() - collision_obj.get_collider().global_position
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

# TODO: handles the physical change to the player
func update_state() -> void:
	match player_state:
		GlobalEnums.PlayerState.Small:
			debug_label.text = "Small"
		GlobalEnums.PlayerState.Normal:
			debug_label.text = "Normal"
		GlobalEnums.PlayerState.Big:
			debug_label.text = "Big"

# functions to add and remove effects affecting on player
# for now it only handles wind. but should be easy to expand.
func add_effect(fan_id: int, push_direction: Vector3) -> void:
	effects.set(fan_id, push_direction)

func remove_effect(fan_id: int) -> void:
	effects.erase(fan_id)

# TODO: add grow and shrink values
func _on_node_eat_candy(candy_type: GlobalEnums.CandyType) -> void:
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
