extends Node
class_name AudioManager

var normal_music: AudioStream = preload("res://assets/audio/normal.mp3")
var small_music: AudioStream = preload("res://assets/audio/small.mp3")

@export var audio_player: AudioStreamPlayer
var curr_audio: GlobalEnums.AudioName

func _ready() -> void:
	Global.audio_manager = self

func play(new_audio: GlobalEnums.AudioName) -> void:
	match new_audio:
		GlobalEnums.AudioName.Normal : 
			curr_audio = GlobalEnums.AudioName.Normal
			audio_player.stream = normal_music
		GlobalEnums.AudioName.Small : 
			curr_audio = GlobalEnums.AudioName.Small
			audio_player.stream = small_music
		_ :
			curr_audio = GlobalEnums.AudioName.Normal
			audio_player.stream = normal_music
	audio_player.play()

func stop() -> void:
	curr_audio = GlobalEnums.AudioName.None
	audio_player.stop()
