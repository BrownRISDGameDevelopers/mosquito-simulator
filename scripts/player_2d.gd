extends CharacterBody2D

const SPEED = 500
const LOSE_SCREEN = preload("res://scenes/LoseScreen.tscn")

@onready var minigame = get_parent()
@onready var level_container = get_node(".")


func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir:
		velocity.x = input_dir.x * SPEED
		velocity.y = input_dir.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity.y > 0:
		$PlayerSprite.flip_v = true
	else:
		$PlayerSprite.flip_v = false

	move_and_slide()

	#checking if player is still
	if (abs(velocity.x) < 0.01 && abs(velocity.y) < 0.01):
		Global.player_still.emit(true)
	else:
		Global.player_still.emit(false)

func get_swatted():
	if Global.lives_left > 1:
		Global.lives_left -= 1
	else:
		print("lost")
		get_tree().change_scene_to_packed(LOSE_SCREEN)
