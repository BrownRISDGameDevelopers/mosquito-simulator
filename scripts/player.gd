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
signal minigame_toggle

const SPEED = 5
const JUMP_VELOCITY = 4.5

signal sucked_blood

@onready var blood_bar = $"../Camera3D/Control"

var on_camper = false
var can_attach = true

var current_camper

@onready var epicycle_timer = $EpicycleTimer
@export var hover_distance = 0.1
@export var hover_height = 0.2
@export var hover_freq = 4

func _ready():
	hover_height = hover_height / hover_distance
	epicycle_timer.wait_time = 2 * PI / hover_freq

func _physics_process(delta: float) -> void:
	if on_camper:
		global_position = current_camper.global_position + hover_distance * epicycle()
		return
	# Add the gravity.
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
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		horizontal_velocity = horizontal_velocity.move_toward(target_velocity, ACCELERATION * delta)

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	print(current_speed)
	if Input.is_action_just_pressed("suck"):
		_add_blood()
	

	move_and_slide()
	
func _add_blood():
	emit_signal("sucked_blood")
	blood_bar._on_sucked_blood()

func cycle_helper(t, min_bound, max_bound):
	if min_bound * PI <= t and t <= max_bound * PI:
		return 1
	else:
		return 0

func epicycle():
	var t = epicycle_timer.time_left * hover_freq
	var r = (cycle_helper(t, 0.0, 0.5) * 1 / cos(t - 0.25 * PI) +
		 cycle_helper(t, 0.5, 1.0) * 1 / cos(t - 0.75 * PI) +
		 cycle_helper(t, 1.0, 1.5) * 1 / cos(t - 1.25 * PI) +
		 cycle_helper(t, 1.5, 2.0) * 1 / cos(t - 1.75 * PI))
	return Vector3(cos(t) * r, hover_height, sin(t) * r)

func return_control():
	on_camper = false
	global_position -= hover_distance * epicycle()

func _on_area_3d_body_entered(body: Node3D):
	if not on_camper and can_attach:
		minigame_toggle.emit()
		on_camper = true
		can_attach = false
		current_camper = body

func _on_area_3d_body_exited(body: Node3D):
	can_attach = true
