extends Node2D

class_name Hand

@export var hand:Sprite2D
@export var handHitBox: Area2D

@export var handSprites: Dictionary[String, Texture2D] = {
	"OpenHand" : null,
	"ClosedHand": null
}

var grabbedItem: RigidBody2D = null


signal grab_item(item:RigidBody2D, info: bool)
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if hand:
		hand.position = get_local_mouse_position();

func _physics_process(_delta: float) -> void:
	if grabbedItem != null:
		grabbedItem.global_position = get_global_mouse_position()
		
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
				var candidate: RigidBody2D = area.get_parent() as RigidBody2D
				if candidate == null:
					continue

				grabbedItem = candidate
				grabbedItem.freeze = true
				grab_item.emit(grabbedItem, true)
				#currently only grab one
				break;
	if Input.is_action_just_released("Grab"):
		hand.texture = handSprites["OpenHand"]
		if grabbedItem != null:
			var releasedItem: RigidBody2D = grabbedItem
			grabbedItem.freeze = false
			grab_item.emit(releasedItem, false)
			grabbedItem = null
