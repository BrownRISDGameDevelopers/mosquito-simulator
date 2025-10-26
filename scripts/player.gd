extends CharacterBody3D

class_name Player

signal minigame_toggle(camper)
signal change_blood_rate(fast_drain: bool)
signal sucked_blood

const SPRINT_SPEED: float = 4
const NORMAL_SPEED: float = 2
const ACCELERATION: float = 2.5
const DECELERATION: float = 2

var current_speed: float = 1
var accelerating: bool = false

var on_camper = false
var can_attach = true

var current_camper

@onready var epicycle_timer = $EpicycleTimer
@export var hover_distance = 0.1
@export var hover_height = 0.2
@export var hover_freq = 4

func _ready():
	current_speed = NORMAL_SPEED
	hover_height = hover_height / hover_distance
	epicycle_timer.wait_time = 2 * PI / hover_freq

func _physics_process(delta: float) -> void:
	if on_camper:
		global_position = current_camper.global_position + hover_distance * epicycle()
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	player_movement(delta)
		
	if Input.is_action_just_pressed("suck"):
		_add_blood()

	move_and_slide()

func player_movement(delta):
	# handling sprinting
	var sprint_req := Input.is_action_pressed("sprint");
	if sprint_req and not accelerating:
		accelerating = true
		current_speed = SPRINT_SPEED
		change_blood_rate.emit(true)

	elif not sprint_req and accelerating:
		accelerating = false
		current_speed = NORMAL_SPEED
		change_blood_rate.emit(false)
	
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
	
func _add_blood():
	sucked_blood.emit()

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
	return Vector3(cos(t) * r, hover_height, cos(t) * sin(t) * r)

func return_control():
	on_camper = false
	current_camper = null
	global_position -= hover_distance * epicycle()

# will be obsoleted with bite prompt

func _on_area_3d_body_entered(body: Node3D):
	if not on_camper and can_attach:
		minigame_toggle.emit(body)
		on_camper = true
		can_attach = false
		current_camper = body

func _on_area_3d_body_exited(body: Node3D):
	can_attach = true
