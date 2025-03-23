extends Area3D

var ran_aready: bool = false

func _on_body_entered(body: Node3D) -> void:
	if not ran_aready:
		ran_aready = true
		Dialogic.start('intro')
