extends Control

@onready var blood_left = 100
@onready var tex = $TextureProgressBar

func _ready():
	update()

func _on_timer_timeout() -> void:
	update()
	

func update():
	print(blood_left)
	blood_left -= 1
	tex.value = blood_left	
	
func _on_sucked_blood():
	blood_left += 10
	print("sucking blood")
	if (blood_left > 100):
		blood_left = 100
