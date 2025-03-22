extends Node3D

# Here we can check if all the pressure plates that are a child of this node are activated or not.

var candy_count: int:
	set(v):
		candy_count = v
		if candy_count == 0:
			print("level done")
	get:
		return candy_count

func _ready() -> void:
	for child in get_children():
		if child.is_in_group("Candy"):
			candy_count += 1

func _on_child_exiting_tree(node: Node) -> void:
	if node.is_in_group("Candy"):
		candy_count -= 1
