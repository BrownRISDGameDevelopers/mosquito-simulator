extends CharacterBody3D

class_name NPC

signal add_swatter(num_swatters)

var rng = RandomNumberGenerator.new()

@export var is_bitten: bool = false
@export var prompt: Sprite3D

var movement_speed: float = rng.randf_range(0.5, 2.0)
var bit_camper: NPC
var panicking = false
var panic_timer = 0.
var swatting = false

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var npc_sprite: AnimatedSprite3D = $NPCSprite
@export var npc_frames: SpriteFrames

func set_random_target(range: float = 10.0):
	# generate random coords in world space
	var random_x = rng.randf_range(-range, range)
	var random_z = rng.randf_range(-range, range)
	var random_position = Vector3(random_x, 0, random_z)

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
	bit_camper = camper
	set_target_by_position(bit_camper.global_position)
	if bit_camper == self:
		panic()

func clear_camper_target():
	if bit_camper == self:
		calm_down()
	swatting = false
	bit_camper = null

func panic():
	panicking = true

func calm_down():
	panicking = false
	set_random_target()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	await get_tree().physics_frame

	# Set initial random target
	set_random_target()


func _on_navigation_finished():
	# When the NPC reaches its target, set a new random target
	npc_sprite.stop()
	await get_tree().create_timer(rng.randf_range(1.0, 5.0)).timeout # Wait a bit
	if bit_camper == null:
		set_random_target()
	elif bit_camper != self:
		set_target_by_position(bit_camper.global_position)

func _ready():
	npc_sprite.sprite_frames = npc_frames
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	prompt = $Prompt

	add_to_group("npcs") # maintain list

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() and not panicking:
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	if not panicking:
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	else:
		panic_timer += delta
		velocity = Vector3(cos(panic_timer * PI * movement_speed), 0, 0)

	var angle = atan2(velocity.z, velocity.x)
	if abs(angle) < 0.25 * PI:
		npc_sprite.play("walk_right")
	elif abs(angle) > 0.75 * PI:
		npc_sprite.play("walk_left")
	elif angle > 0.0:
		npc_sprite.play("walk_forward")
	else:
		npc_sprite.play("walk_backward")
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D):
	if body is Player and not swatting:
		add_swatter.emit(2)
		swatting = true