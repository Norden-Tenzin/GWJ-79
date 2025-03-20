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
	_push_away_rigid_bodies()
	move_and_slide()

func _push_away_rigid_bodies() -> void:
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir: Vector3 = -c.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir: float = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			const MY_APPROX_MASS_KG = 80.0
			var mass_ratio: float = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force: float = mass_ratio * 5.0
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)
