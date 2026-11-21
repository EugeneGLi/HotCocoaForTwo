extends Node2D

class_name Hand

@export var hand:Sprite2D
@export var handHitBox: Area2D
@export_range(0.0, 40.0, 0.1) var hand_follow_speed := 18.0

@export var handSprites: Dictionary[String, Texture2D] = {
	"OpenHand" : null,
	"ClosedHand": null
}

var grabbed_item: RigidBody2D
var grab_offset := Vector2.ZERO
var previous_freeze := false
var previous_freeze_mode := 0


func _physics_process(delta: float) -> void:
	if hand:
		var target_position := get_local_mouse_position()
		hand.position = hand.position.lerp(target_position, 1.0 - exp(-hand_follow_speed * delta))

	if not is_instance_valid(grabbed_item):
		grabbed_item = null
		return

	var target_item_position := handHitBox.global_position + grab_offset
	grabbed_item.move_and_collide(target_item_position - grabbed_item.global_position)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Grab") and not event.is_echo():
		if hand:
			hand.texture = handSprites.get("ClosedHand")
		if not is_instance_valid(grabbed_item):
			_try_grab_closest()
	elif event.is_action_released("Grab"):
		if hand:
			hand.texture = handSprites.get("OpenHand")
		_release_grabbed_item()


func _try_grab_closest() -> void:
	if not handHitBox:
		return

	var shape_node := handHitBox.get_child(0) as CollisionShape2D
	if not shape_node or not shape_node.shape:
		return

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape_node.shape
	query.transform = shape_node.global_transform
	query.collision_mask = handHitBox.collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var closest_item: RigidBody2D
	var closest_distance_squared := INF
	var space_state := get_world_2d().direct_space_state
	for result: Dictionary in space_state.intersect_shape(query, 64):
		var area := result.get("collider") as Area2D
		if not area or not area.is_in_group("Grabbable"):
			continue

		var item := area.get_parent() as RigidBody2D
		if not item:
			continue

		var distance_squared := handHitBox.global_position.distance_squared_to(item.global_position)
		if distance_squared < closest_distance_squared:
			closest_item = item
			closest_distance_squared = distance_squared

	if not closest_item:
		return

	grabbed_item = closest_item
	grab_offset = grabbed_item.global_position - handHitBox.global_position
	previous_freeze = grabbed_item.freeze
	previous_freeze_mode = grabbed_item.freeze_mode
	grabbed_item.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	grabbed_item.freeze = true


func _release_grabbed_item() -> void:
	if is_instance_valid(grabbed_item):
		grabbed_item.freeze_mode = previous_freeze_mode
		grabbed_item.freeze = previous_freeze
		if not previous_freeze:
			grabbed_item.linear_velocity = Vector2.ZERO
			grabbed_item.angular_velocity = 0.0

	grabbed_item = null
	grab_offset = Vector2.ZERO
