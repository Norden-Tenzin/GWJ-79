extends Node3D

var is_door_open: bool = false
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Handle Signals
#func _open_door() -> void:
	#is_door_open = true
	#animation_player.play("Open")

#func _close_door() -> void:
	#is_door_open = false
	#animation_player.play_backwards("Open")
