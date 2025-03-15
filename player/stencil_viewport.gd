extends SubViewport

@onready var stencil_viewport : SubViewport = $"."
@onready var stencil_camera : Camera3D = $Camera3D

func _ready() -> void:
	size = get_tree().root.size
	get_tree().root.size_changed.connect(_on_root_viewport_size_changed)
	
func _on_root_viewport_size_changed() -> void:
	size = get_tree().root.size

func _process(_delta : float) -> void:
	var viewport := get_viewport()
	var current_camera := viewport.get_camera_3d()

	if stencil_viewport.size != viewport.size:
		stencil_viewport.size = viewport.size

	if current_camera:
		stencil_camera.fov = current_camera.fov
		stencil_camera.global_transform = current_camera.global_transform
