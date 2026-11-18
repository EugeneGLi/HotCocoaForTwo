extends Node2D

class_name Hand

@export var hand:Sprite2D
@export var handHitBox: Area2D
var grabbedItem: Node = null


signal grab_item(info: bool)
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if hand:
		hand.position = get_local_mouse_position();


@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if not hand:
		return
	if Input.is_action_pressed("Grab"):
		#check for collisions
		for area: Area2D in handHitBox.get_overlapping_areas():
			#if grabbable
			if area.is_in_group("Grabbable"):
				#grab
				grabbedItem = area.get_parent()
				grab_item.emit(true)
				#currently only grab one
				break;
	if Input.is_action_just_released("Grab"):
		grabbedItem = null
		grab_item.emit(false)
