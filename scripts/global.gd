extends Node

const LEVEL_CONTAINER = preload("res://scenes/LevelContainer.tscn")

var starting_level
var lives_left = 3
var tutorial_completed = false

var current_level = null
