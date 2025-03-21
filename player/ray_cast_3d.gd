extends RayCast3D

func _physics_process(delta: float) -> void:
	if is_colliding():
		print("jump!")
		$"../AnimationTree".get("parameters/playback").travel("Running Jump")
