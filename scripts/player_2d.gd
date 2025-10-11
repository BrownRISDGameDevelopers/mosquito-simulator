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