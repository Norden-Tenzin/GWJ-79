extends CharacterBody3D
class_name Player

@onready var debug_label: Label3D = %DebugLabel

@export var speed: float = 10
@export var jump_velocity: int = 4
@export var player_state: GlobalEnums.PlayerState = GlobalEnums.PlayerState.Normal

# TODO: pick push_force
@export var push_force: float = 5.0

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
	push_player()
	move_and_slide()

func push_player() -> void:
	var final_push_direction: Vector3
	for id in effects:
		var push_direction: Vector3 = effects[id]
		final_push_direction = (final_push_direction + push_direction).normalized()
	# TODO: pick a push_force
	match player_state:
		GlobalEnums.PlayerState.Small:
			velocity += final_push_direction * push_force
		GlobalEnums.PlayerState.Normal:
			velocity += final_push_direction * push_force
		GlobalEnums.PlayerState.Big:
			velocity += final_push_direction * push_force

# TODO: handles the physical change to the player
func update_state() -> void:
	match player_state:
		GlobalEnums.PlayerState.Small:
			debug_label.text = "Small"
		GlobalEnums.PlayerState.Normal:
			debug_label.text = "Normal"
		GlobalEnums.PlayerState.Big:
			debug_label.text = "Big"

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
