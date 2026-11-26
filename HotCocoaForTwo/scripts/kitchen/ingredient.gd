extends Node2D
##ingredient
class_name Ingredient

var isGrabbed = false;
var toFollow: Node2D
@onready var rigidBody : RigidBody2D = %GrabbableTemplate
@export var max_speed : float = 1250
@export var max_offset : float = 100
@export var angular_damping := 8.0
@export var area2d : Area2D
var current_grav
func _ready() -> void:
	current_grav = rigidBody.gravity_scale

##Document
@warning_ignore("unused_parameter")
func _physics_process(_delta: float) -> void:
	if isGrabbed and toFollow != null:
		var destination := get_local_mouse_position()
		var current := rigidBody.position
		var distance := destination - current
		#print(str(destination) + " + " + str(current) + " = " + str(distance))
		var is_far_away := distance.length() > max_offset
		rigidBody.linear_velocity = (distance / _delta).limit_length(max_speed)
		rigidBody.angular_velocity = move_toward(rigidBody.angular_velocity, 0.0, angular_damping * _delta * 10.0)


##thing
func _on_main_thingy_grab_item(info: bool, hand: Area2D) -> void:
	if hand != area2d:
		return
	isGrabbed = info
	toFollow = hand;
	if info:
		rigidBody.angular_velocity = 0
	rigidBody.gravity_scale = 0 if info else current_grav

# To add a new ingredient kind type a new name inside the { } below
# Make sure to add the name at the end of the list and add a color for it in pot.gd
enum Type { CHOCOLATE, MILK, MARSHMALLOW }
@export var type: Type = Type.CHOCOLATE
# Used to stop the pot from counting the ingredient that was just dropped, twice
var is_used: bool = false

# Called by the pot when it accepts this ingredient
func use_up() -> void:
	is_used = true
	queue_free() # delete this node safely at the end of the frame
