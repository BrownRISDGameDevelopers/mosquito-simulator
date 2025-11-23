extends CharacterBody2D

@export var player: CharacterBody2D

var prev_position = global_position
@export var swat_interval = 1.0
@export var swat_speed = 1.0
@export var movement_speed = 200.0
var target_index: int

var player_in_hitbox = false
@export var swatting = false
@onready var swat_timer = $SwatTimer
@onready var anim_player = $AnimationPlayer
@onready var slap_fail: AudioStreamPlayer = $SlapFail

func _ready():
	target_index = randi_range(0, 6)
	swat_timer.wait_time = swat_interval
	anim_player.speed_scale = swat_speed

func _physics_process(delta):
	if player:
		var angle = (swat_timer.time_left / swat_interval) * 8 * PI
		var target = player.get_target(target_index).global_position + Vector2(cos(angle) * movement_speed, sin(angle) * movement_speed) / 4
		velocity = target - prev_position
	if swatting:
		velocity = Vector2.ZERO
	prev_position = global_position
	velocity = velocity.normalized() * movement_speed
	move_and_slide()

func swat_player():
	if player_in_hitbox:
		player.get_swatted()
	else:
		slap_fail.play()

func post_swat():
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
		swat_timer.stop()
		player_in_hitbox = false

func _on_timer_timeout():
	target_index += 1
