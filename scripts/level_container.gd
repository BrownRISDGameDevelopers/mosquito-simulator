extends Control

var minigame_visible = false

@onready var map_viewport = $MapViewport/SubViewport

func _ready() -> void:
	set_level(Global.starting_level)

func set_level(map: PackedScene):
	var level_instance = map.instantiate()
	for child in map_viewport.get_children():
		child.queue_free()
	map_viewport.add_child(level_instance)

func _on_map_minigame_toggle():
	minigame_visible = !minigame_visible
	$MinigameViewport.visible = minigame_visible
	if minigame_visible:
		$MapViewport.scale = Vector2(0.25, 0.25)
	if not minigame_visible:
		$MapViewport.scale = Vector2.ONE
