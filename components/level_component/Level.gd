extends Node3D
# Here we can check if all the pressure plates 
# that are a child of this node are activated or not.

signal eat_candy(candy_type: GlobalEnums.CandyType)

@export var music_name: GlobalEnums.MusicName = GlobalEnums.MusicName.Small

var candy_count: int:
	set(v):
		candy_count = v
		if candy_count == 0:
			candy_status = true
			level_end_check()
	get:
		return candy_count

var candy_status: bool = false
var plate_status: Dictionary[int, bool] = {}

func _ready() -> void:
	if Global.audio_manager:
		Global.audio_manager.play(music_name)
	# Connects candy signals to a single function
	for child in get_children():
		if child.is_in_group("Candy"):
			child.connect("candy_picked_up", _candy_picked_up)
			candy_count += 1
		if child.is_in_group("PressurePlate"):
			child.connect("plate_state_changed", _plate_state_changed)

# candy picked_up signals
func _candy_picked_up(candy_type: GlobalEnums.CandyType) -> void:
	candy_count -= 1
	eat_candy.emit(candy_type)

func _plate_state_changed(plate_id: int, plate_state: bool) -> void:
	plate_status.set(plate_id, plate_state)

# checks if all candies are picked up and all plates are true
func level_end_check() -> void:
	if candy_status and plate_status.values().all(
		func(element: bool) -> bool: return element == true
	): 
		level_end()

func level_end() -> void:
	pass
