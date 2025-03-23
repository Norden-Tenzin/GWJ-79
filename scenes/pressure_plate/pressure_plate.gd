extends Node3D

signal plate_state_changed(plate_id: int, plate_state: bool)

@onready var frame: MeshInstance3D = $Pressure_Frame
@onready var button: MeshInstance3D = $Pressure_Button
var glow: ShaderMaterial

@onready var debug_label: Label3D = %DebugLabel
@export var plate_type: GlobalEnums.PlateType

var plate_state: bool = false

func _ready() -> void:
	glow = frame.mesh.surface_get_material(1)

func _process(delta: float) -> void:
	update_visuals(delta * 3.0)

func _on_area_component_node_entered(body: Node3D) -> void:
	match plate_type:
		GlobalEnums.PlateType.Switch:
			plate_state = true
		GlobalEnums.PlateType.Hold:
			plate_state = true
	plate_state_changed.emit(self.get_instance_id(), plate_state)
	debug_label.text = str(plate_state)

func _on_area_component_node_exited(body: Node3D) -> void:
	match plate_type:
		GlobalEnums.PlateType.Switch:
			pass
		GlobalEnums.PlateType.Hold:
			plate_state = false
	plate_state_changed.emit(self.get_instance_id(), plate_state)
	debug_label.text = str(plate_state)

func update_visuals(lerp_alpha: float) -> void:
	glow.set_shader_parameter("intensity", lerp(glow.get_shader_parameter("intensity"), 3.0 if plate_state else 0.0, lerp_alpha / 2.0))
	button.scale.y = lerp(button.scale.y, 0.2 if plate_state else 1.0, lerp_alpha)
