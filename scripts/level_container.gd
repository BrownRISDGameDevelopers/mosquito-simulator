extends Control

var playing_minigame = false

@onready var map_viewport = $MapViewport/SubViewport
@onready var map_3d = $MapViewport/SubViewport/Map
@onready var minigame_viewport = $MinigameViewport
@onready var minigame = $MinigameViewport/SubViewport/SwatMinigame
@onready var hearts = [$Heart3, $Heart2, $Heart1]
# @onready var infinite_mode: bool = false

const WIN_SCREEN = preload("res://scenes/WinScreen.tscn")


const MAP = preload("res://scenes/Map.tscn")
@onready var npcs # update in set_level: npc will register themselves

signal player_win

func _ready() -> void:
	if Engine.is_editor_hint():
		set_level(Global.starting_level)
	else:
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

	npcs = get_tree().get_nodes_in_group("npcs")

func toggle_minigame(minigame_state):
	playing_minigame = minigame_state
	minigame_viewport.visible = playing_minigame
	if playing_minigame:
		minigame_viewport.process_mode = Node.PROCESS_MODE_PAUSABLE
		$MapViewport.scale = Vector2(0.25, 0.25)
	if not playing_minigame:
		minigame_viewport.process_mode = Node.PROCESS_MODE_DISABLED
		$MapViewport.scale = Vector2.ONE

func _process(_delta) -> void:
	if Global.current_level == "infinite":
		if all_npc_bitten():
			emit_signal("player_win")
			get_tree().change_scene_to_packed(WIN_SCREEN) # display win screen

	#heart removal
	if Global.lives_left != hearts.size():
		var heart_to_remove = hearts.get(0)
		heart_to_remove.visible = false
		hearts.remove_at(0)
			

func on_map_3d_minigame_toggle():
	toggle_minigame(true)
	minigame.reset()

func _on_swat_minigame_exited_bounds():
	toggle_minigame(false)
	map_3d.free_player()

func on_map_3d_add_swatter_to_minigame(num_swatters):
	minigame.add_swatter(num_swatters)

# checks if all npcs are bitten and returns true if so
func all_npc_bitten() -> bool:
	for npc in npcs:
		if npc.is_bitten == false:
			return false
	return true
