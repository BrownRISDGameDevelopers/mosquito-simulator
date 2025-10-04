extends CharacterBody3D

class_name Player

var SPEED = 1
var accelerating: bool = false
const JUMP_VELOCITY = 4.5
const ACCELERATE_SPEED = 2
const NORMAL_SPEED = 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var accelearte_req := Input.is_action_pressed("accelerate");
	if accelearte_req and not accelerating:
		accelerating = true
		SPEED = ACCELERATE_SPEED
		#

	elif not accelearte_req and accelerating:
		accelerating = false
		SPEED = NORMAL_SPEED

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
