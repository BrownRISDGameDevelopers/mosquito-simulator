extends CharacterBody2D

const SPEED = 500

func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir:
		velocity.x = input_dir.x * SPEED
		velocity.y = input_dir.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

	#checking if player is still
	if (velocity.x < 0.05 && velocity.y < 0.05):
		Global.player_still.emit(true)
	else:
		Global.player_still.emit(false)

func get_swatted():
	$Label.text = $Label.text + "ouch"