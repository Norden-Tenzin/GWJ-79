extends Node
class_name AudioManager

# How to add more audio tracks
# 1. add a preaload var in this file
# 2. create a enum for that file in GlobalEnum.AudioName
# 3. handle that enum in play 

var normal_music: AudioStream = preload("res://assets/audio/music/normal.mp3")
var small_music: AudioStream = preload("res://assets/audio/music/small.mp3")
var level_1: AudioStream = preload("res://assets/audio/music/LV1loop.ogg")
var level_2: AudioStream = preload("res://assets/audio/music/LV2song.ogg")
var level_3: AudioStream = preload("res://assets/audio/music/LV3loop.ogg")

@export var music_player: AudioStreamPlayer
var curr_audio: GlobalEnums.MusicName

func _ready() -> void:
	Global.audio_manager = self

func play(new_music: GlobalEnums.MusicName) -> void:
	if curr_audio != new_music:
		match new_music:
			GlobalEnums.MusicName.Normal : 
				curr_audio = GlobalEnums.MusicName.Normal
				self.play_audio(music_player, normal_music)
			GlobalEnums.MusicName.Small : 
				curr_audio = GlobalEnums.MusicName.Small
				self.play_audio(music_player, small_music)
			GlobalEnums.MusicName.Level_1 : 
				curr_audio = GlobalEnums.MusicName.Level_1
				self.play_audio(music_player, level_1)
			GlobalEnums.MusicName.Level_2 : 
				curr_audio = GlobalEnums.MusicName.Level_2
				self.play_audio(music_player, level_2)
			GlobalEnums.MusicName.Level_3 : 
				curr_audio = GlobalEnums.MusicName.Level_3
				self.play_audio(music_player, level_3)
			_ :
				curr_audio = GlobalEnums.MusicName.Normal
				self.play_audio(music_player, normal_music)

func play_audio(audio_player: AudioStreamPlayer, audio: AudioStream) -> void:
	audio_player.stream = audio
	audio_player.play()

func stop() -> void:
	curr_audio = GlobalEnums.MusicName.None
	music_player.stop()
