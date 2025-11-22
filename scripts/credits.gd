extends Control

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_return_mouse_exited() -> void:
	$Return.material.set_shader_parameter("enabled", false)


func _on_return_mouse_entered() -> void:
	$Return.material.set_shader_parameter("enabled", true)