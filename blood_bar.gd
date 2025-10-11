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

@onready var blood_left = 100

func _ready():
	update()

func _on_timer_timeout() -> void:
	update()
	

func update():
	print("updating")
	blood_left -= 1
	$ProgressBar.value = blood_left
	
func _on_sucked_blood():
	blood_left += 10
	print("sucking blood")
	if (blood_left > 100):
		blood_left = 100
