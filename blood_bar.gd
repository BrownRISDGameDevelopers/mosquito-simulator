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

@export var FAST_DEPLETION = 4
@export var NORMAL_DEPLETION = 1

@export var blood_left = 100
@onready var blood_deplete_rate = 1

@onready var blood_sucked = 0
const BLOOD_BOOST = 20; #amount of blood added to the timer upon successful minigame completion
const BLOOD_SUCK_RATE = 10; #how much blood is sucked per second


func _ready():
	update()
	$TimeLeft.start()
	Global.start_minigame.connect(_start_minigame)
	Global.player_still.connect(_on_player_still)
	$BloodSucked.timeout.connect(_on_blood_sucked_timeout)

func _on_timer_timeout() -> void:
	update()
	
func update():
	print("updating")
	blood_left -= blood_deplete_rate
	$ProgressBar.value = blood_left

func _start_minigame():
	print("started minigame")
	$TimeLeft.stop()
	$ProgressBar.value = 0

#when the player is staying still
func _on_player_still(is_still: bool):
	if ($TimeLeft.is_stopped()):
		print("in minigame. is_still " + str(is_still))
		print(is_still)
		if is_still:
			$BloodSucked.start()
			print("	player is still, in the minigame, and blood sucking")
		else:
			print("	player moved, stopped")
			$BloodSucked.stop()

func _on_blood_sucked_timeout() -> void:
	print("	sucking blood")
	blood_sucked += 10
	print(" " + str(blood_sucked))
	print(" ProgressBar value" + str($ProgressBar.value))
	$ProgressBar.value = blood_sucked
	if blood_sucked > 100:
		print("	successful completion")
		Global.completed_minigame.emit()
		$ProgressBar.value = blood_left + BLOOD_BOOST #reset progress bar back to showing time left
		$BloodSucked.stop()
		$TimeLeft.start()
