extends Control

var playing_minigame = false
@export var in_tutorial = true

@onready var map_viewport = $MapViewport/SubViewport
@onready var map_3d = $MapViewport/SubViewport/Map
@onready var minigame_viewport = $MinigameViewport
@onready var minigame = $MinigameViewport/SubViewport/SwatMinigame
@onready var hearts = [$Heart3, $Heart2, $Heart1]
# @onready var infinite_mode: bool = false
@onready var blood_bar: Control = $BloodBar

const WIN_SCREEN = preload("res://scenes/WinScreen.tscn")
const LOSE_SCREEN = preload("res://scenes/LoseScreen.tscn")

const MAIN_MAP = preload("res://scenes/Map.tscn")
const TUTORIAL_MAP = preload("res://scenes/TutorialMap.tscn")

const LOAD_SCREEN = preload("res://scenes/Loading.tscn")

var CURR_MAP

@onready var npcs # update in set_level: npc will register themselves

signal player_win
signal player_lose

func _ready() -> void:
	if Engine.is_editor_hint():
		# use a safe value if Global.starting_level is null
		var start_map = Global.starting_level if Global.starting_level != null else (TUTORIAL_MAP if in_tutorial else MAIN_MAP)
		set_level(start_map)
	else:
		CURR_MAP = Global.starting_level if Global.starting_level != null else (TUTORIAL_MAP if in_tutorial else MAIN_MAP)
		set_level(CURR_MAP)
		
	toggle_minigame(playing_minigame)

# Accepts PackedScene, a resource path string, or null — will fallback and log errors.
func set_level(map) -> void:
	# If caller passed a path string, try to load it
	if typeof(map) == TYPE_STRING:
		var loaded = load(map)
		if loaded == null:
			push_error("level_container.set_level: failed to load scene from path: %s — falling back" % map)
			map = null
		else:
			map = loaded

	# If map is null, choose sensible default
	if map == null:
		push_warning("level_container.set_level: received null map — using fallback default.")
		map = TUTORIAL_MAP if in_tutorial else MAIN_MAP

	# At this point map should be a PackedScene / resource
	if not map:
		push_error("level_container.set_level: no valid map available after fallback. Aborting.")
		return

	var level_instance = map.instantiate()
	# clear existing children
	for child in map_viewport.get_children():
		child.queue_free()
	map_viewport.add_child(level_instance)
	map_3d = level_instance

	# connect signals only if the instance provides them
	if level_instance.has_signal("add_swatter_to_minigame"):
		map_3d.add_swatter_to_minigame.connect(on_map_3d_add_swatter_to_minigame)
	else:
		# optional: log for debugging
		# push_warning("map instance missing signal: add_swatter_to_minigame")
		pass

	if level_instance.has_signal("minigame_toggle"):
		map_3d.minigame_toggle.connect(on_map_3d_minigame_toggle)
	else:
		# push_warning("map instance missing signal: minigame_toggle")
		pass

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
	# lose condition
	if blood_bar.blood_left < 0:
		emit_signal("player_lose")
		if in_tutorial:
			get_tree().change_scene_to_packed(LOAD_SCREEN)
		else: 
			get_tree().change_scene_to_packed(LOSE_SCREEN) # display lose screen

	# win condition
	if Global.current_level != "infinite":

		if all_npc_bitten():
			emit_signal("player_win")
			if in_tutorial:
				get_tree().change_scene_to_packed(LOAD_SCREEN)
			else: 
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
