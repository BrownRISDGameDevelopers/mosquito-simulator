extends CharacterBody3D

class_name Player

signal minigame_toggle(camper)
signal sucked_blood

const SPRINT_SPEED: float = 4
const NORMAL_SPEED: float = 2
const ACCELERATION: float = 2.5
const DECELERATION: float = 2

const MIN_DISTANCE_TO_NPC: float = 0.5

var current_speed: float = 1

var on_camper = false
var can_attach = true

var current_camper: NPC
var closest_camper

@onready var epicycle_timer = $EpicycleTimer
@export var hover_distance = 0.1
@export var hover_height = 0.2
@export var hover_freq = 4

func _ready():
	current_speed = NORMAL_SPEED
	hover_height = hover_height / hover_distance
	epicycle_timer.wait_time = 2 * PI / hover_freq
	Global.successful_bite.connect(func(): current_camper.is_bitten = true)

func _physics_process(delta: float) -> void:
	if on_camper:
		global_position = current_camper.global_position + hover_distance * epicycle()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	player_movement(delta)

	for npc in get_tree().get_nodes_in_group("npcs"):
		npc.prompt.visible = false

	closest_camper = get_nearest_npc()
	if closest_camper:
		closest_camper.prompt.visible = true
	
	if Input.is_action_just_pressed("suck") and closest_camper and not on_camper:
		minigame_toggle.emit(closest_camper)
		on_camper = true
		can_attach = false
		current_camper = closest_camper

	move_and_slide()

func toggle_bite_prompt():
	pass

func get_nearest_npc():
	var npcs = get_tree().get_nodes_in_group("npcs")
	var nearest_npc = null
	var nearest_distance = INF

	for npc in npcs:
		var dist = global_position.distance_to(npc.global_position)
		if dist < nearest_distance:
			nearest_distance = dist
			nearest_npc = npc
	
	if nearest_distance > MIN_DISTANCE_TO_NPC:
		return null

	if nearest_npc.is_bitten:
		return null
	
	return nearest_npc

func player_movement(delta):
	# handling sprinting
	var sprint_req := Input.is_action_pressed("sprint");
	if sprint_req and not Global.sprinting:
		Global.sprinting = true
		current_speed = SPRINT_SPEED

	elif not sprint_req and Global.sprinting:
		Global.sprinting = false
		current_speed = NORMAL_SPEED
	
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
	pass
	# if not on_camper and can_attach:
	# 	minigame_toggle.emit(body)
	# 	on_camper = true
	# 	can_attach = false
	# 	current_camper = body

func _on_area_3d_body_exited(body: Node3D):
	can_attach = true
