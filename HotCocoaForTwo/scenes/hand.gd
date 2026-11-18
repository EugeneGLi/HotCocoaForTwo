extends Node2D

class_name Hand

var hand:Sprite2D
var handHitBox: Area2D
var grabbedItem: Node
signal grab_item(info: bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand = %hand;
	handHitBox = %HandHitBox

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	hand.position = get_local_mouse_position();


@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	pass
	if Input.is_action_pressed("Grab"):
		#check for collisions
		for area: Area2D in handHitBox.get_overlapping_areas():
			#if grabbable
			if area.is_in_group("Grabbable"):
				#grab
				#print("lifting!");
				grab_item.emit(true)
				#currently only grab one
				break;
	if Input.is_action_just_released("Grab"):
		grab_item.emit(false)
		
