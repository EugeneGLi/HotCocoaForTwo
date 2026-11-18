extends RigidBody2D
class_name GrabbableObject

var isGrabbed = false;
var grav = 10
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if isGrabbed:
		position = get_global_mouse_position();
		freeze = true
	else:
		freeze = false


func _on_main_thingy_grab_item(info: bool) -> void:
	isGrabbed = info
