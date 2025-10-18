extends CharacterBody3D

class_name Player

signal minigame_toggle(camper)

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
	return Vector3(cos(t) * r, hover_height, cos(t) * sin(t) * r)

func return_control():
	on_camper = false
	global_position -= hover_distance * epicycle()

func _on_area_3d_body_entered(body: Node3D):
	if not on_camper and can_attach:
		minigame_toggle.emit(body)
		on_camper = true
		can_attach = false
		current_camper = body

func _on_area_3d_body_exited(body: Node3D):
	can_attach = true
