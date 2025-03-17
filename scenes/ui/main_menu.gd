extends Control

func _ready() -> void:
	Global.audio_manager.play(GlobalEnums.AudioName.Normal)

func _on_new_game_button_pressed() -> void:
	print("NEW GAME PRESSED")
	Global.scene_manager.change_3d_scene("res://scenes/levels/level_template.tscn")
	self.queue_free()

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
