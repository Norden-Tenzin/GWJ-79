extends Node3D

var is_door_open: bool = false
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	Dialogic.timeline_ended.connect(_dialog_ended)

func _dialog_ended() -> void:
	print("DOOR OPENS")
	animation_player.play("Open")
	Dialogic.timeline_ended.disconnect(_dialog_ended)

# Handle Signals
#func _open_door() -> void:
	#is_door_open = true
	#animation_player.play("Open")

#func _close_door() -> void:
	#is_door_open = false
	#animation_player.play_backwards("Open")
