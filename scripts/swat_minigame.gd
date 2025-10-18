extends Node2D

signal exited_bounds

@onready var player = $Player2D

func _on_minigame_bounds_body_exited(body: Node2D):
	exited_bounds.emit()

func reset():
	player.position = Vector2.ZERO
