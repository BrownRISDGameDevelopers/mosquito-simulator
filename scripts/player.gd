extends CharacterBody3D

class_name Player


const SPEED = 5
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
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

	move_and_slide()

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is NPC:
		print("entered npc")
		var bubble_scene = preload("res://scenes/SpeechBubble.tscn")
		var bubble = bubble_scene.instantiate()

		var camera = get_tree().current_scene.get_node("Camera3D")
		var world_pos = body.global_position + Vector3(0, 0, 0)  # offset above head
		var screen_pos = camera.unproject_position(world_pos)
		bubble.global_position = screen_pos

		get_tree().current_scene.get_node("CanvasLayer").add_child(bubble)
