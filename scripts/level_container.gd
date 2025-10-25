extends Control

var minigame_visible = false

@onready var map_viewport = $MapViewport/SubViewport
@onready var minigame = $MinigameViewport/SubViewport/SwatMinigame
@onready var infinite_mode: bool = false

const WIN_SCREEN = preload("res://scenes/WinScreen.tscn")

var map_3d = null
@onready var npcs # update in set_level: npc will register themselves

signal player_win

func _ready() -> void:
	set_level(Global.starting_level)

func set_level(map: PackedScene):
	var level_instance = map.instantiate()
	for child in map_viewport.get_children():
		child.queue_free()
	map_viewport.add_child(level_instance)
	map_3d = level_instance

	npcs = get_tree().get_nodes_in_group("npcs")

func toggle_minigame(minigame_state):
	minigame_visible = minigame_state
	$MinigameViewport.visible = minigame_visible
	if minigame_visible:
		$MapViewport.scale = Vector2(0.25, 0.25)
	if not minigame_visible:
		$MapViewport.scale = Vector2.ONE

func _process(_delta) -> void:
	if not infinite_mode:
		if all_npc_bitten():
			# add_child(win_screen)
			# win_screen.visible = true
			emit_signal("player_win")
			get_tree().change_scene_to_packed(WIN_SCREEN) # display win screen
			

func _on_map_minigame_toggle():
	toggle_minigame(true)
	minigame.reset()


func _on_swat_minigame_exited_bounds():
	toggle_minigame(false)
	map_3d.free_player()

# checks if all npcs are bitten and returns true if so
func all_npc_bitten() -> bool:
	for npc in npcs:
		if npc.is_bitten == false:
			return false
	return true
