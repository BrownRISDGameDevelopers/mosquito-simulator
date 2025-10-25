extends CharacterBody3D

class_name NPC

signal add_swatter

var rng = RandomNumberGenerator.new()

var movement_speed: float = rng.randf_range(1.0, 3.0)
@export var is_bitten: bool = false
var bit_camper: NPC

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func set_random_target():
	# generate random coords in world space
	var random_x = rng.randf_range(-10.0, 10.0)
	var random_z = rng.randf_range(-10.0, 10.0)
	var random_position = Vector3(random_x, global_position.y, random_z)
	set_target_by_position(random_position)


func set_target_by_position(target_position):
	var nav_map = navigation_agent.get_navigation_map()

	# snap to navmesh
	var closest_point = NavigationServer3D.map_get_closest_point(nav_map, target_position)
	navigation_agent.set_target_position(closest_point)

	# confirm that the point is actually reachable
	if not navigation_agent.is_target_reachable():
		# try again if unreachable
		set_random_target()

func set_camper_target(camper: NPC):
	bit_camper = camper
	set_target_by_position(bit_camper.global_position)
	if bit_camper == self:
		panic()

func clear_camper_target():
	if bit_camper == self:
		calm_down()
	bit_camper = null

func panic():
	print("I'm panicking")

func calm_down():
	print("I calmed down")
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Set initial random target
	set_random_target()


func _on_navigation_finished():
	# When the NPC reaches its target, set a new random target
	await get_tree().create_timer(rng.randf_range(1.0, 5.0)).timeout # Wait a bit
	if bit_camper == null:
		set_random_target()
	else:
		set_target_by_position(bit_camper.global_position)

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	add_to_group("npcs") # maintain list

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D):
	if body is Player:
		add_swatter.emit()
