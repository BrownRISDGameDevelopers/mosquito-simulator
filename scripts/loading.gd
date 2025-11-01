extends Control

class_name LoadingScreen

signal loading_complete

@onready var background: TextureRect = $Background
@onready var mosquito: TextureRect = $Mosquito
@onready var camera: Camera2D = $Camera2D
@onready var loadingLabel: Label = $LoadingLabel

const AMP = 60
const LOADING_TIME = 15
const STARTING_Y = 540.0
const END_X = 4519.0

var running_delta = 0

func loading_finished():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 1.0)
	await tween.finished
	loading_complete.emit()
	
func _ready() -> void:
	background.position = Vector2.ZERO

	var x_tween = create_tween()
	x_tween.tween_property(mosquito, "position:x", END_X, LOADING_TIME)
	x_tween.tween_callback(loading_finished).set_delay(1.5)

	var mosquito_tween = create_tween()
	mosquito.position = Vector2(473, STARTING_Y)
	mosquito_tween.tween_property(mosquito, "position:y", STARTING_Y + AMP, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	mosquito_tween.tween_property(mosquito, "position:y", STARTING_Y - AMP, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	mosquito_tween.set_loops()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var camera_pos = clamp(mosquito.position.x - 960 / 2, 0, background.size.x - 1920)
	camera.position = Vector2(camera_pos, 0)
	loadingLabel.position = Vector2(camera_pos + 1920 - loadingLabel.size.x - 150, 930)

	running_delta += _delta
	if running_delta > 0.3:
		running_delta = 0
		var dots = loadingLabel.visible_characters - len("Loading")
		dots = (dots + 1) % 4

		loadingLabel.visible_characters = len("Loading") + dots
