extends Node2D
##ingredient
class_name Ingredient

var isGrabbed = false;
@onready var rigidBody : RigidBody2D = %GrabbableTemplate

##Document
@warning_ignore("unused_parameter")
func _physics_process(_delta: float) -> void:
	if isGrabbed:
		rigidBody.linear_velocity = Input.get_last_mouse_velocity()
		rigidBody.angular_velocity = 0

##thing
func _on_main_thingy_grab_item(info: bool) -> void:
	isGrabbed = info
