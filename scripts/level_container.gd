extends Control

var minigame_visible = false

@onready var map_viewport = $MapViewport/SubViewport
@onready var minigame = $MinigameViewport/SubViewport/SwatMinigame
var map_3d = null

func _ready() -> void:
	set_level(Global.starting_level)

func set_level(map: PackedScene):
	var level_instance = map.instantiate()
	for child in map_viewport.get_children():
		child.queue_free()
	map_viewport.add_child(level_instance)
	map_3d = level_instance

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
