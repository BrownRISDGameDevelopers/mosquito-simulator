extends Node2D

signal exited_bounds

@export var swatter_distance = 800

@onready var player = $Player2D
@export var swatter_scene: PackedScene

var extra_swatters = []
var num_swatters = 0

func _ready():
	add_swatter(1)

func _on_minigame_bounds_body_exited(body: Node2D):
	exited_bounds.emit()

func add_swatter(swatter_adj = 0):
	num_swatters += swatter_adj
	if swatter_adj < 0:
		return
	var swatter_angle = randf() * 2 * PI
	var swatter_offset = Vector2(cos(swatter_angle), sin(swatter_angle)) * swatter_distance
	var new_swatter: Node2D = swatter_scene.instantiate()
	new_swatter.player = player
	new_swatter.position = swatter_offset
	extra_swatters.append(new_swatter)
	new_swatter.scale /= $Hand.scale
	new_swatter.rotation = -$Hand.rotation
	$Hand.add_child(new_swatter)

func reset():
	for swatter in extra_swatters:
		swatter.queue_free()
	extra_swatters = []
	for i in range(num_swatters):
		add_swatter()
	player.position = Vector2.ZERO
