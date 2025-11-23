extends NPC

class_name Cow

var direction = 1
var moving = true

func set_random_target(range: float = 1.0):
	# generate random coords in world space
	var random_x = rng.randf_range(-range, range)
	var random_position = Vector3(random_x, 0, global_position.z)
	print(random_position)
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
	return

func clear_camper_target():
	return

func panic():
	panicking = true

func calm_down():
	panicking = false
	set_random_target()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Set initial random target
	set_random_target()


func _on_navigation_finished():
	# When the NPC reaches its target, set a new random target
	npc_sprite.stop()
	await get_tree().create_timer(rng.randf_range(1.0, 5.0)).timeout # Wait a bit
	set_random_target()


func _ready():
	npc_sprite.sprite_frames = npc_frames
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	if randf() < 0.5:
		direction = - direction

	prompt = $Prompt

	add_to_group("npcs") # maintain list

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func _physics_process(delta):
	var current_agent_position: Vector3 = global_position

	if moving:
		velocity = Vector3(direction, 0, 0)
		$NPCSprite.flip_h = direction < 0
	else:
		velocity = Vector3.ZERO

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D):
	if body is Player:
		add_swatter.emit(1)


func _on_area_3d_body_exited(body):
	if body is Player:
		add_swatter.emit(-1)


func _on_movement_timer_timeout():
	if moving:
		moving = false
	else:
		moving = true
		direction = - direction
