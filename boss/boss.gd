extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var direction = Vector3()
var root_velocity = Vector3.ZERO

func _process(delta):
	var root_pos = $"y bot walk/AnimationPlayer".get_root_motion_position()
	var current_rotation = ($"y bot walk/AnimationPlayer".get_root_motion_rotation_accumulator().inverse() * get_quaternion())
	root_velocity = current_rotation * root_pos / delta


func _physics_process(delta: float) -> void:
	nav.target_position = Global.player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	var target = global_position + direction
	look_at(target)
	velocity = -root_velocity
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
