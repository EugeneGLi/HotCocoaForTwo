
##the main way of interaction.
## controled by the mouse.
class_name Hand
extends Node2D
##the sprite the follows the mouse
@export var hand:Sprite2D
@export var handHitBox: Area2D
@export var velocity: Vector2
##data structure holding the various sprits of the hand
@export var handSprites: Dictionary[String, Texture2D] = {
	"OpenHand" : null,
	"ClosedHand": null
}

var grabbedItem: Node = null

##called when the hand interacts with a grabbable item
signal grab_item(info: bool, hand: Area2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grabbables()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if hand:
		var new_position = get_local_mouse_position()
		hand.position = new_position


@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if not hand:
		return
	if Input.is_action_pressed("Grab"):
		#check for collisions
		hand.texture = handSprites["ClosedHand"]
	if Input.is_action_just_pressed("Grab"):
		for area: Area2D in handHitBox.get_overlapping_areas():
			#if grabbable
			if area.is_in_group("Grabbable"):
				#grab
				grabbedItem = area
				grab_item.emit(true, area)
				#currently only grab one
				break;
	if Input.is_action_just_released("Grab"):
		hand.texture = handSprites["OpenHand"]
		grab_item.emit(false, grabbedItem)
		grabbedItem = null

##connects all grabbable objects in the scene to
##the grab signal the hand emits when interacting with a grabbable area
##a grabbable object must have a _on_main_thingy_grab_item method, or nothing will happen
##ALSO ALSO, the node with that script should be the grandparent of the grabbable area
func setup_grabbables() -> void:
	for node in get_tree().get_nodes_in_group("Grabbable"):
		node = node.get_parent().get_parent()
		if(node.get_script() == null):
			print(error_string(ERR_CANT_ACQUIRE_RESOURCE) + ": given node " +  str(node) + "does not have a script to handle grabbing")
			continue
		grab_item.connect(node._on_main_thingy_grab_item)
