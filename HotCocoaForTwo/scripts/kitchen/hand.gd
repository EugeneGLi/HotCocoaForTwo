extends Node2D

class_name Hand

@export var hand:Sprite2D
@export var handHitBox: Area2D
@export var velocity: Vector2
@export var handSprites: Dictionary[String, Texture2D] = {
	"OpenHand" : null,
	"ClosedHand": null
}

var grabbedItem: Node = null


signal grab_item(info: bool, hand: Area2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Grabbable"):

		node = node.get_parent().get_parent()

		if(node.get_script() == null):
			print(error_string(ERR_CANT_ACQUIRE_RESOURCE) + ": given node " +  str(node) + "does not have a script to handle grabbing")
			continue
		grab_item.connect(node._on_main_thingy_grab_item)


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
