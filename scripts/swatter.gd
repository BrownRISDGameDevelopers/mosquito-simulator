extends CharacterBody2D

@export var player: CharacterBody2D

@export var swat_interval = 1.0
@export var swat_speed = 1.0
@export var movement_speed = 200.0

@export var swatting = false
var player_in_hitbox = false
@onready var swat_timer = $SwatTimer
@onready var anim_player = $AnimationPlayer

func _ready():
	reset_timer()
	anim_player.speed_scale = swat_speed

func reset_timer():
	swat_timer.wait_time = 3 * randi_range(8, 12) / (10 * swat_interval)

func _physics_process(delta):
	if player:
		velocity = player.global_position - global_position
	if swatting:
		velocity = Vector2.ZERO
	velocity = velocity.normalized() * movement_speed
	move_and_slide()

func swat_player():
	if player_in_hitbox:
		player.get_swatted()

func post_swat():
	reset_timer()
	swatting = false

func _on_swat_timer_timeout():
	swatting = true
	anim_player.play("swat")

func _on_swat_hitbox_body_entered(body: Node2D):
	if body == player:
		swat_timer.start()
		player_in_hitbox = true

func _on_swat_hitbox_body_exited(body: Node2D):
	if body == player:
		player_in_hitbox = false
