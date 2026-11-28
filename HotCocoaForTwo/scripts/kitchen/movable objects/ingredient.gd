##ingredients that are added to the pot
class_name Ingredient
extends MovableObject

enum Type { CHOCOLATE, MILK, MARSHMALLOW }
@export var type: Type = Type.CHOCOLATE
func handle_grabbed(_delta: float) -> void:
	if isGrabbed and toFollow != null:
			var destination := get_local_mouse_position()
			var current := rigidBody.position
			var distance := destination - current
			#print(str(destination) + " + " + str(current) + " = " + str(distance))
			rigidBody.linear_velocity = (distance / _delta).limit_length(max_speed)
			rigidBody.angular_velocity = move_toward(rigidBody.angular_velocity, 0.0, angular_damping * _delta * 10.0)
func _on_main_thingy_grab_item(info: bool, hand: Area2D) -> void:
	if hand != area2d:
		return
	isGrabbed = info
	toFollow = hand;
	if info:
		rigidBody.angular_velocity = 0
	rigidBody.gravity_scale = 0 if info else current_grav

# Used to stop the pot from counting the ingredient that was just dropped, twice
var is_used: bool = false

# Called by the pot when it accepts this ingredient
func use_up() -> void:
	is_used = true
	queue_free() # delete this node 
