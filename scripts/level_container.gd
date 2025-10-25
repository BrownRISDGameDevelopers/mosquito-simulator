extends Control

var playing_minigame = false

@onready var map_viewport = $MapViewport/SubViewport
@onready var map_3d = $MapViewport/SubViewport/Map
@onready var minigame_viewport = $MinigameViewport
@onready var minigame = $MinigameViewport/SubViewport/SwatMinigame

const MAP = preload("res://scenes/Map.tscn")

func _ready() -> void:
	# set_level(Global.starting_level)
	set_level(MAP)
	toggle_minigame(playing_minigame)

func set_level(map: PackedScene):
	var level_instance = map.instantiate()
	for child in map_viewport.get_children():
		child.queue_free()
	map_viewport.add_child(level_instance)
	map_3d = level_instance
	map_3d.add_swatter_to_minigame.connect(on_map_3d_add_swatter_to_minigame)
	map_3d.minigame_toggle.connect(on_map_3d_minigame_toggle)

func toggle_minigame(minigame_state):
	playing_minigame = minigame_state
	minigame_viewport.visible = playing_minigame
	if playing_minigame:
		minigame_viewport.process_mode = Node.PROCESS_MODE_PAUSABLE
		$MapViewport.scale = Vector2(0.25, 0.25)
	if not playing_minigame:
		minigame_viewport.process_mode = Node.PROCESS_MODE_DISABLED
		$MapViewport.scale = Vector2.ONE


func on_map_3d_minigame_toggle():
	toggle_minigame(true)
	minigame.reset()


func _on_swat_minigame_exited_bounds():
	toggle_minigame(false)
	map_3d.free_player()

func on_map_3d_add_swatter_to_minigame(num_swatters):
	minigame.add_swatter(num_swatters)
