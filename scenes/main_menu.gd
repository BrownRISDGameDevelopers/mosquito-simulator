extends Node3D

func _on_StartButton_pressed():
    get_tree().change_scene_to_file(res://scenes/Map.tscn)
