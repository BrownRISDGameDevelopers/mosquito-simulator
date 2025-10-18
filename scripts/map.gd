extends Node3D

signal minigame_toggle

@onready var player = $Player

func _on_player_minigame_toggle():
	minigame_toggle.emit()

func free_player():
	player.return_control()
