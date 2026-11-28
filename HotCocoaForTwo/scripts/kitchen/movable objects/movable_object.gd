
##abstract class describing a movable object
##this includes foodstuffs and any other objects that would behave similarly when picked up
@abstract class_name MovableObject
extends Node2D
@export var isGrabbed = false;
var toFollow: Node2D
@export var rigidBody : RigidBody2D
@export var area2d : Area2D
@export var max_speed : float = 1250
@export var max_offset : float = 100
@export var angular_damping := 8.0
var current_grav
func _ready() -> void:
	current_grav = rigidBody.gravity_scale

@abstract func handle_grabbed(_delta: float) -> void
@abstract func _on_main_thingy_grab_item(info: bool, hand: Area2D) -> void

# To add a new ingredient kind type a new name inside the { } below
# Make sure to add the name at the end of the list and add a color for it in pot.gd
func _physics_process(delta: float) -> void:
	handle_grabbed(delta)
