extends Node3D

signal minigame_toggle

func _on_player_minigame_toggle():
	minigame_toggle.emit()