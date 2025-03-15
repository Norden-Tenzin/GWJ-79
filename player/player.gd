extends CharacterBody3D


const SPEED = 10
const JUMP_VELOCITY = 4

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Global.player = self

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
