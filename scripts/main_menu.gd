extends Control

const LEVEL_CONTAINER_PATH := "res://scenes/LevelContainer.tscn"
const CREDITS = preload("res://scenes/Credits.tscn")

const TUTORIAL = preload("res://scenes/TutorialMap.tscn")
const MAIN_MAP = preload("res://scenes/Map.tscn")
const INFINITE_MODE = preload("res://scenes/InfiniteModeMap.tscn")

func _ready() -> void:
	var buttons: Array[TextureButton] = [$StartButton, $InfiniteMode, $Quit, $Credits]

	for button in buttons:
		# var image = button.texture_normal
		# var bitmap = BitMap.new()
		# bitmap.create_from_image_alpha(image)
		# button.texture_click_mask = bitmap
		print(button)

		button.mouse_entered.connect(func() -> void:
			print('hover', button.name)
			button.material.set_shader_parameter("enabled", true)
			button.scale = button.scale * 1.05
			button.position -= Vector2(10, 10)
		)

		button.mouse_exited.connect(func() -> void:
			button.material.set_shader_parameter("enabled", false)
			button.scale = button.scale / 1.05
			button.position += Vector2(10, 10)
		)

func _on_start_button_pressed() -> void:
	print("Start pressed")
	print(LEVEL_CONTAINER_PATH)
	print(Global)

	if !Global.tutorial_completed:
		Global.starting_level = TUTORIAL
	else:
		Global.starting_level = MAIN_MAP
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
	Global.current_level = "infinite"
	var packed = load(LEVEL_CONTAINER_PATH)
	if packed == null:
		push_error("Failed to load LevelContainer scene at: %s" % LEVEL_CONTAINER_PATH)
		return
	get_tree().change_scene_to_packed(packed)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_infinite_mode_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)
