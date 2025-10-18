extends Control

const LEVEL_CONTAINER = preload("res://scenes/LevelContainer.tscn")
const CREDITS = preload("res://scenes/Credits.tscn")

const TUTORIAL = preload("res://scenes/TutorialMap.tscn")
const INFINITE_MODE = preload("res://scenes/InfiniteModeMap.tscn")


func _on_start_button_pressed() -> void:
	Global.starting_level = TUTORIAL
	get_tree().change_scene_to_packed(LEVEL_CONTAINER)


func _on_infinite_mode_pressed() -> void:
	# Global.starting_level = INFINITE_MODE
	# get_tree().change_scene_to_packed(LEVEL_CONTAINER)
	print("infinite mode")
	Global.starting_level = INFINITE_MODE
	get_tree().change_scene_to_packed(LEVEL_CONTAINER)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_infinite_mode_button_pressed() -> void:
	pass # Replace with function body.
