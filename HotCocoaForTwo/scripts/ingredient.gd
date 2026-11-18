extends Node2D
class_name Ingredient

var isGrabbed = false;
@warning_ignore("unused_parameter")
func _process(_delta: float) -> void:
	if isGrabbed:
		%GrabbableTemplate.global_position = get_global_mouse_position()

func _on_main_thingy_grab_item(info: bool) -> void:
	isGrabbed = info
	%GrabbableTemplate.freeze = info
