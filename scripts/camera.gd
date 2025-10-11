extends Camera3D

const OFFSET = Vector3(0, 0.85, 0.5)
const FOLLOW_SPEED = 5

@export var player: Player

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player:
		global_position = player.position + OFFSET


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		global_position = player.position + OFFSET
