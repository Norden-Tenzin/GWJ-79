extends Node3D

@export var candy_count: int:
	set(v):
		candy_count = v
		if candy_count == 0:
			pass
	get:
		return candy_count
