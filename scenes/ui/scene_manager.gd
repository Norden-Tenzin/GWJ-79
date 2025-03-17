extends Node
class_name SceneManager

@export var world3d: Node3D
@export var gui: Control
@export var transition_manager: TransitionManager

var curr_3d_scene: Node3D
var curr_gui_scene: Control

func _ready() -> void:
	Global.scene_manager = self
	curr_gui_scene = $GUI/SplashScreenManager

# a pause menu
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		# checks if the world3d has children aka gamein in play
		if world3d.get_children().size() > 0:
			var children: Array[Node] = gui.get_children()
			if children.size() > 0:
				get_tree().paused = !get_tree().paused
				for child in children:
					child.queue_free()
			else:
				get_tree().paused = !get_tree().paused
				Global.scene_manager.change_gui_scene(
					"res://scenes/ui/pause_menu.tscn",
					true,
					false,
					false
				)

func change_3d_scene(
	new_scene: String,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0
) -> void:
	if transition:
		transition_manager.transition(transition_out, seconds)
		await transition_manager.animation_player.animation_finished
	if curr_3d_scene != null:
		if delete: 
			curr_3d_scene.queue_free()
		elif keep_running:
			curr_3d_scene.visible = false
		else:
			gui.remove_child(curr_3d_scene)
	var new_scene_obj: Node3D = load(new_scene).instantiate()
	world3d.add_child(new_scene_obj)
	curr_3d_scene = new_scene_obj
	if transition:
		transition_manager.transition(transition_in, seconds)

func change_gui_scene(
	new_scene: String,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0
) -> void:
	if transition:
		transition_manager.transition(transition_out, seconds)
		await transition_manager.animation_player.animation_finished
	if curr_gui_scene != null:
		if delete: 
			curr_gui_scene.queue_free()
		elif keep_running:
			curr_gui_scene.visible = false
		else:
			gui.remove_child(curr_gui_scene)
	var new_scene_obj: Control = load(new_scene).instantiate()
	gui.add_child(new_scene_obj)
	curr_gui_scene = new_scene_obj
	if transition:
		transition_manager.transition(transition_in, seconds)
