extends Camera3D

var direction: Basis = Basis()

func _ready() -> void:
	direction.x = transform.basis.x
	direction.z = -transform.basis.z
	direction.x.y = 0
	direction.z.y = 0

func _input(e: InputEvent) -> void:
	if Input.is_action_pressed("camera mode change"):
		if transform.origin.x == 15:
			transform = $"../O2".transform
			#size = 12
			direction.x = transform.basis.x
			direction.z = transform.basis.y
			direction.x.y = 0
			direction.z.y = 0
		elif transform.origin.z == 0:
			transform = $"../O3".transform
			size = 8
			direction.x = transform.basis.x
			direction.z = -transform.basis.z
			direction.x.y = 0
			direction.z.y = 0
		else:
			transform = $"../O1".transform
			#size = 12
			direction.x = transform.basis.x
			direction.z = -transform.basis.z
			direction.x.y = 0
			direction.z.y = 0

#
#var rot_x: float = 0
#var rot_y: float = 0
#var LOOKAROUND_SPEED: float = 0.006
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rot_x += event.relative.x * LOOKAROUND_SPEED
		#rot_y += event.relative.y * LOOKAROUND_SPEED
		#transform.basis = Basis()
		#$"..".transform.basis = Basis()
		#$"..".rotate_object_local(Vector3(0, 1, 0), -rot_x)
		#if rot_y > PI / 2:
			#rot_y = PI / 2 - 0.05
		#elif rot_y < -PI / 2:
			#rot_y = -PI / 2 + 0.05
		#rotate_object_local(Vector3(1, 0, 0), -rot_y)
	#
