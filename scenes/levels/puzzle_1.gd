extends Node3D

signal eat_candy(candy_type: GlobalEnums.CandyType)

@export var candy_count: int = 0

func _ready() -> void:
	Global.audio_manager.play(GlobalEnums.MusicName.Small)
	# Connects candy signals to a single function
	for child in get_children():
		if child.is_in_group("Candy"):
			child.connect("candy_picked_up", _candy_picked_up)

# All candy picked_up signals
func _candy_picked_up(candy_type: GlobalEnums.CandyType) -> void:
	candy_count -= 1
	eat_candy.emit(candy_type)
	if candy_count == 0:
		level_end()

# Game level_lost signals
func _on_area_3d_level_lost() -> void:
	Global.scene_manager.reset_3d_scene()

func level_end() -> void:
	pass
