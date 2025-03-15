extends Camera3D

var rot_x: float = 0
var rot_y: float = 0
var LOOKAROUND_SPEED: float = 0.006
func _input(event: InputEvent) -> void:
  if event is InputEventMouseMotion:
    rot_x += event.relative.x * LOOKAROUND_SPEED
    rot_y += event.relative.y * LOOKAROUND_SPEED
    transform.basis = Basis()
    $"..".transform.basis = Basis()
    $"..".rotate_object_local(Vector3(0, 1, 0), -rot_x)
    if rot_y > PI / 2:
      rot_y = PI / 2 - 0.05
    elif rot_y < -PI / 2:
      rot_y = -PI / 2 + 0.05
    rotate_object_local(Vector3(1, 0, 0), -rot_y)
    
