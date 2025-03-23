extends ShapeCast3D

var box: RigidBody3D
var last_text: String

func _physics_process(delta: float) -> void:
	if is_colliding():
		if get_collider(0).is_class("RigidBody3D"):
			box = get_collider(0)
			$"../AnimationTree".set("parameters/conditions/near box", true)
			%DebugLabel.text = "Press E to interact"
		else:
		$	"../AnimationTree".set("parameters/conditions/near box", false)
			%DebugLabel.text = ""
