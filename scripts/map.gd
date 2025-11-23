extends Node3D

signal minigame_toggle
signal set_camper_target
signal clear_camper_target
signal add_swatter_to_minigame(num_swatters)
signal change_blood_rate
signal sucked_blood

@onready var player = $Player
@onready var targetable_camera = $Camera3D
@onready var bgm: AudioStreamPlayer = $Bgm
@onready var noise: AudioStreamPlayer = $Noise

func _ready():
	for camper in get_tree().get_nodes_in_group("Campers"):
		set_camper_target.connect(camper.set_camper_target)
		clear_camper_target.connect(camper.clear_camper_target)
		camper.add_swatter.connect(add_swatter)

func add_swatter(num_swatters):
	add_swatter_to_minigame.emit(num_swatters)

func free_player():
	clear_camper_target.emit()
	targetable_camera.camper = null
	player.return_control()

func _on_player_minigame_toggle(camper):
	set_camper_target.emit(camper)
	targetable_camera.camper = camper
	minigame_toggle.emit()

func _on_player_change_blood_rate(fast_drain: bool):
	change_blood_rate.emit()

func _on_player_sucked_blood():
	sucked_blood.emit()

func stop_playing_music():
	if bgm:
		bgm.stop()
	noise.stop()

func play_music():
	if bgm:
		bgm.play()
	noise.play()
