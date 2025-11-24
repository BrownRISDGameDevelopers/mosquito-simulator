extends Node3D

signal minigame_toggle
signal set_camper_target
signal clear_camper_target
signal add_swatter_to_minigame(num_swatters)
signal change_blood_rate
signal sucked_blood

var swamp_signal_connected = false

@onready var player = $Player
@onready var targetable_camera = $Camera3D
@onready var bgm: AudioStreamPlayer = $Bgm
@onready var noise: AudioStreamPlayer = $Noise

var rng = RandomNumberGenerator.new()
var start_times = {}
var curr_time = 0

var NPC_SCENE = load("uid://1ayg4tlicupc")
var NPC_FRAMES = [load("uid://bh3ny7rbnfxrh"),
					load("uid://28pi6mthg8s3"),
					load("uid://xvfueoljxv3q")]

func _ready():
	Global.minigame_toggle.connect(_on_player_minigame_toggle)
	swamp_signal_connected = true
	Global.add_swamp_npc_signal.connect(add_swamp_npc)
	for camper in get_tree().get_nodes_in_group("Campers"):
		set_camper_target.connect(camper.set_camper_target)
		clear_camper_target.connect(camper.clear_camper_target)
		camper.add_swatter.connect(add_swatter)

func _physics_process(delta):
	if not swamp_signal_connected:
		swamp_signal_connected = true
		Global.add_swamp_npc_signal.connect(add_swamp_npc)

func add_swamp_npc():
	var npc = NPC_SCENE.instantiate()
	npc.npc_frames = NPC_FRAMES[rng.randi_range(0, NPC_FRAMES.size() - 1)]
	add_child(npc)
	npc.position = Vector3(rng.randf_range(-8, 8), 0.25, rng.randf_range(-8, 8))

	set_camper_target.connect(npc.set_camper_target)
	clear_camper_target.connect(npc.clear_camper_target)
	npc.add_swatter.connect(add_swatter)

	Global.current_swamp_npc = npc

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
