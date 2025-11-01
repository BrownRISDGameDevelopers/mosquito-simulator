extends Control

const LEVEL_CONTAINER = preload("res://scenes/LevelContainer.tscn")
const CREDITS = preload("res://scenes/Credits.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)


func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_CONTAINER)


func _on_quit_pressed() -> void:
	get_tree().quit()
