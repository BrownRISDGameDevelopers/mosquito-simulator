extends Node3D

signal minigame_toggle
signal set_camper_target
signal clear_camper_target

@onready var player = $Player
@onready var targetable_camera = $Camera3D

func _ready():
	for camper in get_tree().get_nodes_in_group("Campers"):
		set_camper_target.connect(camper.set_camper_target)
		clear_camper_target.connect(camper.clear_camper_target)

func _on_player_minigame_toggle(camper):
	set_camper_target.emit(camper)
	targetable_camera.camper = camper
	minigame_toggle.emit()

func free_player():
	clear_camper_target.emit()
	targetable_camera.camper = null
	player.return_control()
