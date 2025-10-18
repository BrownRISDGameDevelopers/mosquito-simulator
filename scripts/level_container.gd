extends Control

var minigame_visible = false

@onready var map_3d = $MapViewport/SubViewport/Map
@onready var minigame = $MinigameViewport/SubViewport/SwatMinigame

func toggle_minigame(minigame_state):
	minigame_visible = minigame_state
	$MinigameViewport.visible = minigame_visible
	if minigame_visible:
		$MapViewport.scale = Vector2(0.25, 0.25)
	if not minigame_visible:
		$MapViewport.scale = Vector2.ONE


func _on_map_minigame_toggle():
	toggle_minigame(true)
	minigame.reset()


func _on_swat_minigame_exited_bounds():
	toggle_minigame(false)
	map_3d.free_player()
