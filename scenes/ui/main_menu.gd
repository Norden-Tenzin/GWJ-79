extends Control

func _ready() -> void:
	Global.audio_manager.play(GlobalEnums.MusicName.Small)

# Menu
func _on_start_game_button_pressed() -> void:
	#Global.scene_manager.change_3d_scene(GlobalEnums.SceneName.Level1_0)
	Global.scene_manager.change_3d_scene(GlobalEnums.SceneName.Level3_1)
	self.queue_free()

func _on_settings_button_pressed() -> void:
	Global.scene_manager.change_gui_scene(
		GlobalEnums.SceneName.SettingsMainMenu,
		true,
		false,
		false
	)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
