extends Node2D

signal exited_bounds

@onready var player = $Player2D
@export var swatter_scene: PackedScene

var extra_swatters = []

func _on_minigame_bounds_body_exited(body: Node2D):
	exited_bounds.emit()

func add_swatter():
	var swatter_angle = randf() * 2 * PI
	var swatter_offset = Vector2(cos(swatter_angle), sin(swatter_angle)) * 800
	var new_swatter = swatter_scene.instantiate()
	new_swatter.player = player
	new_swatter.position = swatter_offset
	extra_swatters.append(new_swatter)
	add_child(new_swatter)

func reset():
	for swatter in extra_swatters:
		swatter.queue_free()
	extra_swatters = []
	player.position = Vector2.ZERO
