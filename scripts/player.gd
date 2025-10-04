extends CharacterBody3D

class_name Player

signal minigame_toggle

const SPEED = 1
const JUMP_VELOCITY = 4.5

var on_camper = false
var current_camper

func _physics_process(delta: float) -> void:
	if on_camper:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_area_3d_body_entered(body: Node3D):
	if not on_camper:
		minigame_toggle.emit()
		on_camper = true
		current_camper = body

func _on_area_3d_body_exited(body: Node3D):
	if on_camper and body == current_camper:
		minigame_toggle.emit()
		on_camper = false
		current_camper = null
