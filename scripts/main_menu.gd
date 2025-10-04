extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Map.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Credits.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_infinite_mode_pressed() -> void:
	print("infinite mode")
