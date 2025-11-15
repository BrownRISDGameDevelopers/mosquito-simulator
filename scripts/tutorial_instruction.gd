extends Control

@export var playing_minigame = false
@onready var suck_blood_instruction: Label = $SuckBloodInstruction
@onready var movement_instruction: Label = $MovementInstruction

func _process(delta: float) -> void:
	if playing_minigame:
		movement_instruction.visible = false
		suck_blood_instruction.visible = true
	else:
		movement_instruction.visible = true
		suck_blood_instruction.visible = false
