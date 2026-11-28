extends Area2D

@onready var hand: Hand = get_parent().get_node("Hand")
@export var knife: RigidBody2D

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseMotion) \
	or not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) \
	or hand.grabbedItem != knife:
		return

	for area: Area2D in get_overlapping_areas():
		if not area.is_in_group("Grabbable"):
			continue

		var shape_node: CollisionShape2D = area.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if shape_node == null or shape_node.shape == null:
			continue

		var local_mouse: Vector2 = shape_node.to_local(get_global_mouse_position())
		if shape_node.shape.get_rect().has_point(local_mouse):
			var ingredientNode: Ingredient = area.get_parent().get_parent() as Ingredient
			if ingredientNode != null and ingredientNode.chop():
				print("Chopped!")
