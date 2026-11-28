class_name Knife
extends MovableObject

@export var grabbedPosition : Node2D
func _ready() -> void:
	super._ready()
	rigidBody.center_of_mass = %"Center of Mass".position
func handle_grabbed(_delta: float) -> void:
	if isGrabbed:
		rigidBody.position = get_local_mouse_position()
		rigidBody.position -= grabbedPosition.position
func _on_main_thingy_grab_item(info: bool, hand: Area2D) -> void:
	if hand != area2d:
		return
	isGrabbed = info
	rigidBody.gravity_scale = 0 if info else current_grav
