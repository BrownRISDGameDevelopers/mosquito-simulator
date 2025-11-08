extends Control

const LEVEL_CONTAINER_PATH := "res://scenes/LevelContainer.tscn"
const CREDITS = preload("res://scenes/Credits.tscn")

const TUTORIAL = preload("res://scenes/TutorialMap.tscn")
const INFINITE_MODE = preload("res://scenes/InfiniteModeMap.tscn")


func _on_start_button_pressed() -> void:
	print("Start pressed")
	print(LEVEL_CONTAINER_PATH)
	print(Global)

	Global.starting_level = TUTORIAL
	# Load at runtime instead of preloading the PackedScene. Preloading can
	# execute script initializers early and cause invalid/empty PackedScene
	# issues in some cases; loading here ensures the resource is read now.
	var packed = load(LEVEL_CONTAINER_PATH)
	if packed == null:
		push_error("Failed to load LevelContainer scene at: %s" % LEVEL_CONTAINER_PATH)
		return

	get_tree().change_scene_to_packed(packed)


func _on_infinite_mode_pressed() -> void:
	# Global.starting_level = INFINITE_MODE
	# get_tree().change_scene_to_packed(LEVEL_CONTAINER)
	print("infinite mode")
	Global.starting_level = INFINITE_MODE
	var packed = load(LEVEL_CONTAINER_PATH)
	if packed == null:
		push_error("Failed to load LevelContainer scene at: %s" % LEVEL_CONTAINER_PATH)
		return
	get_tree().change_scene_to_packed(packed)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_infinite_mode_button_pressed() -> void:
	pass # Replace with function body.
