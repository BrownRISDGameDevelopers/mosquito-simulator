extends Control

@export var npc: Node3D         # The NPC in the 3D world
@export var camera: Camera3D    # The camera viewing the 3D scene
@export var offset: Vector3 = Vector3(0, 2, 0)  # how far above the NPC in 3D

# func _process(delta):
#     if npc and camera:
#         # get the NPC position + offset in world space
#         var world_pos = npc.global_position + offset
#         # project 3D world position to 2D screen coordinates
#         var screen_pos = camera.unproject_position(world_pos)
#         global_position = screen_pos

func _on_button_pressed():
    queue_free()  # remove the bubble
