extends Node3D

signal minigame_toggle

@onready var player = $Player
@onready var targetable_camera = $Camera3D

func _on_player_minigame_toggle(camper):
	targetable_camera.camper = camper
	minigame_toggle.emit()

func free_player():
	targetable_camera.camper = null
	player.return_control()
