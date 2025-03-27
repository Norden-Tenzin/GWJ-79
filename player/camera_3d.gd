extends Camera3D

var direction: Basis = Basis()

func _ready() -> void:
	direction.x = transform.basis.x
	direction.z = -transform.basis.z
	direction.x.y = 0
	direction.z.y = 0
