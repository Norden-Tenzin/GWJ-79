extends CharacterBody3D

enum State
{
	Chasing,
	Patrolling
}

var state: State

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var direction: Vector3 = Vector3()
var root_velocity: Vector3 = Vector3.ZERO
var patrol_path: Array
var index: int = 0
var target_position: Vector3
var timer_lost: Timer = Timer.new()


func _init() -> void:
	add_child(timer_lost)
	timer_lost.wait_time = 5
	timer_lost.autostart = false
	timer_lost.timeout.connect(_on_lost_player)
	
func _on_lost_player() -> void:
	state = State.Patrolling
	timer_lost.stop()

func get_player_visible() -> bool:
	var player: CharacterBody3D = Global.player
	var player_position: Vector3 = player.get_global_transform().origin
	var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(get_global_transform().origin, player_position, 0xFFFFFFFF, [self]))
	if result && result["collider"] != player:
		return false
	var vec: Vector3 = player.get_global_transform().origin - get_global_transform().origin
	vec = vec.normalized()
	var vec2: Vector3 = -1 * get_global_transform().basis.z.normalized()
	if vec2.dot(vec) < 0.707:
		return false
	return true

func _ready() -> void:
	for area: NavigationRegion3D in get_tree().get_nodes_in_group("NavigationArea"):
			if area.get_bounds().intersects_ray(global_position, Vector3.DOWN):
				patrol_path = area.leaves

func _process(delta: float) -> void:
	var root_pos: Vector3 = $"y bot walk/AnimationPlayer".get_root_motion_position()
	var current_rotation: Quaternion = ($"y bot walk/AnimationPlayer".get_root_motion_rotation_accumulator().inverse() * get_quaternion())
	root_velocity = current_rotation * root_pos / delta

func _physics_process(delta: float) -> void:
	if get_player_visible():
		nav.target_position = Global.player.global_position
		state = State.Chasing
	elif state == State.Chasing:
		nav.target_position = Global.player.global_position
		if timer_lost.is_stopped():
			timer_lost.start()
	else:
		nav.target_position = patrol_path[index]
		
	direction = nav.get_next_path_position() - global_position
	direction.y = 0
	direction = direction.normalized()
	var target: Vector3 = global_position + direction
	look_at(target)
	velocity = -root_velocity
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func _on_navigation_agent_3d_navigation_finished() -> void:
	index += 1
	index = index % len(patrol_path)
	target_position = patrol_path[index]
