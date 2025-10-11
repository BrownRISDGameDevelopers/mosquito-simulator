extends Control

var minigame_visible = false

func _on_map_minigame_toggle():
	minigame_visible = !minigame_visible
	$MinigameViewport.visible = minigame_visible
	if minigame_visible:
		$MapViewport.scale = Vector2(0.25, 0.25)
	if not minigame_visible:
		$MapViewport.scale = Vector2.ONE
