extends Control

"""@onready var points = 100
signal death

func _decrease():
	points.x -= 50

func _time_to_die():
	return points ==0;

func _on_timer_timeout() -> void:
	_decrease()
	$TextureProgressBar.value = points
	
	if _time_to_die():
		emit_signal("death")"""

@export var blood_left = 100
const BLOOD_DEPLETE_RATE = .01
const THRESHOLD = 0.01

@onready var blood_sucked = 0
const BLOOD_BOOST = 20; # amount of blood added to the timer upon successful minigame completion
const BLOOD_SUCK_RATE = .05; # how much blood is sucked per second

@onready var progress_bar = $ProgessBar

var minigame_active = false

func _ready():
	update()
	Global.start_minigame.connect(_start_minigame)
	Global.player_still.connect(_on_player_still)

func _on_timer_timeout() -> void:
	update()

var prev = 0.0


func _process(delta: float) -> void:
	if minigame_active:
		return

	prev += delta

	if prev >= THRESHOLD / (2 if Global.sprinting else 1):
		prev = 0.0
		update()
	

func update():
	if Global.sprinting:
		blood_left -= BLOOD_DEPLETE_RATE * 2
	else:
		blood_left -= BLOOD_DEPLETE_RATE
	
	progress_bar.value = blood_left


func _start_minigame():
	minigame_active = true
	progress_bar.value = 0
	blood_sucked = 0

#when the player is staying still
func _on_player_still(standing_still: bool):
	print("start")

	if (minigame_active and standing_still):
		blood_sucked += BLOOD_SUCK_RATE
		progress_bar.value = blood_sucked
		if blood_sucked > 100:
			minigame_active = false
			Global.completed_minigame.emit()
			blood_left = min(blood_left + BLOOD_BOOST, 100)
			progress_bar.value = blood_left # reset progress bar back to showing time left
