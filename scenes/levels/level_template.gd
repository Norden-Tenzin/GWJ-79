extends Node3D

func _ready() -> void:
	Global.audio_manager.play(GlobalEnums.AudioName.Small)
