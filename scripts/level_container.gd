extends Control

var minigame_visible = false

func _on_map_minigame_toggle():
	minigame_visible = !minigame_visible
	$MinigameViewport.visible = minigame_visible