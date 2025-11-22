extends Control

@onready var minigame_instructions: Label = $MinigameInstructions
@onready var movement_instructions: Label = $MovementInstructions
	
func _ready() -> void:
	minigame_instructions.visible = false
	movement_instructions.visible = true

func show_minigame_instructions() -> void:
	minigame_instructions.visible = true
	movement_instructions.visible = false

func show_movement_instructions() -> void:
	minigame_instructions.visible = false
	movement_instructions.visible = true
