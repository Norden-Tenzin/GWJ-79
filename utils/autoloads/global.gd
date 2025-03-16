extends Node

var player: CharacterBody3D
var main: Node
var scene_manager: SceneManager

signal picked_up(type: GlobalEnums.CandyType, candy_node: Node3D)
