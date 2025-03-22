extends Node3D

signal plate_state_changed(plate_id: int, plate_state: bool)

@onready var debug_label: Label3D = %DebugLabel
@export var plate_type: GlobalEnums.PlateType

var plate_state: bool = false

func _ready() -> void:
	pass

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
