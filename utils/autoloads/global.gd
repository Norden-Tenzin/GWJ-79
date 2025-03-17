extends Node

var player: CharacterBody3D
var main: Node
var scene_manager: SceneManager
var audio_manager: AudioManager

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

signal picked_up(type: GlobalEnums.CandyType, candy_node: Node3D)
