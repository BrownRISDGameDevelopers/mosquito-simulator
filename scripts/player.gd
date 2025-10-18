extends CharacterBody3D

class_name Player

const JUMP_VELOCITY: float= 4.5
const SPRINT_SPEED: float = 4
const NORMAL_SPEED: float = 2
const ACCELERATION: float = 2.5
const DECELERATION: float = 2

var current_speed: float = 1
var accelerating: bool = false

func _physics_process(delta: float) -> void:
	player_movement(delta)

	move_and_slide()

func player_movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	# handling sprinting
	var sprint_req := Input.is_action_pressed("sprint");
	if sprint_req and not accelerating:
		accelerating = true
		current_speed = SPRINT_SPEED
	elif not sprint_req and accelerating:
		accelerating = false
		current_speed = NORMAL_SPEED
	
	if accelerating:
		# decrease blood
		pass
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	# transform to vector3
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() 

	var target_velocity := direction * current_speed
	var horizontal_velocity := velocity
	horizontal_velocity.y = 0 # separating horizontal velocity

	if direction == Vector3.ZERO:
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, DECELERATION * delta)
	else:
		horizontal_velocity = horizontal_velocity.move_toward(target_velocity, ACCELERATION * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	print(current_speed)
