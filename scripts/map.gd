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

var rng = RandomNumberGenerator.new()
var start_times = {}
var curr_time = 0

const NPC_SCENE = preload("res://scenes/npc.tscn")
const NPC_FRAMES = [preload("res://resources/swamp_npc1.tres"),
					preload("res://resources/swamp_npc2.tres"),
					preload("res://resources/swamp_npc3.tres")]

func _ready():
	for camper in get_tree().get_nodes_in_group("Campers"):
		set_camper_target.connect(camper.set_camper_target)
		clear_camper_target.connect(camper.clear_camper_target)
		camper.add_swatter.connect(add_swatter)

func add_swamp_npc():
	var npc = NPC_SCENE.instantiate()
	npc.npc_frames = NPC_FRAMES[rng.randi_range(0, NPC_FRAMES.size() - 1)]
	add_child(npc)

	npc.position = Vector3(rng.randf_range(-8, 8), 0, rng.randf_range(-8, 8))

	set_camper_target.connect(npc.set_camper_target)
	clear_camper_target.connect(npc.clear_camper_target)
	npc.add_swatter.connect(add_swatter)

	return npc


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
