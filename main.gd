extends Node

func _ready() -> void:
  Global.main = self
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  
func _input(e: InputEvent) -> void:
  if Input.is_action_pressed("left_click") and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  elif Input.is_action_pressed("escape") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_candy_picked_up(type: GlobalEnums.CandyType, candy_node: Node3D) -> void:
  print("Candy1 picked up now " + str(GlobalEnums.CandyType.keys()[type]))
  candy_node.queue_free()

func _on_candy_2_picked_up(type: GlobalEnums.CandyType, candy_node: Node3D) -> void:
  print("Candy2 picked up now " + str(GlobalEnums.CandyType.keys()[type]))
  candy_node.queue_free()
