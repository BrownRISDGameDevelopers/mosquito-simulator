extends Node

const LEVEL_CONTAINER = preload("res://scenes/LevelContainer.tscn")

var starting_level
var lives_left = 3
var tutorial_completed = false

var current_level = null
var in_tutorial = true

signal start_minigame
signal player_still(is_still: bool)
signal completed_minigame
signal successful_bite
signal add_swamp_npc_signal
signal swamp_npc_added

var current_swamp_npc

signal minigame_toggle(camper)

var sprinting = false

func add_swamp_npc():
    add_swamp_npc_signal.emit()
    return current_swamp_npc