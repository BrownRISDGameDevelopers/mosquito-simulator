extends Control

func _ready() -> void:
	print("bubble created")

func _on_button_pressed():
	queue_free()  # remove the bubble
