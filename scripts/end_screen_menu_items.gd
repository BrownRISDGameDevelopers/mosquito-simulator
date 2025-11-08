extends Control

const LEVEL_CONTAINER = preload("res://scenes/LevelContainer.tscn")
const CREDITS = preload("res://scenes/Credits.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")

@export var label_message = "Insert message in menu"
@onready var label: Label = $VBoxContainer/Label

func _ready() -> void:
	label.text = label_message

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)


func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_CONTAINER)
	# replay function needed....


func _on_quit_pressed() -> void:
	get_tree().quit()
