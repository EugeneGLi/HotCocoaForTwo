extends Node2D

class_name Ingredient

var isGrabbed = false;
var isChopped = false;

func _on_main_thingy_grab_item(item: RigidBody2D, info: bool) -> void:
	if item == %GrabbableTemplate:
		isGrabbed = info

func chop() -> bool:
	if isChopped or isGrabbed:
		return false

	var grabbable: RigidBody2D = %GrabbableTemplate
	var sourceSprite: Sprite2D = grabbable.get_node("Sprite")
	if sourceSprite.texture == null:
		return false

	var textureSize: Vector2 = sourceSprite.texture.get_size()
	var halfWidth: float = textureSize.x / 2.0

	for pieceIndex in range(2):
		var pieceTexture := AtlasTexture.new()
		pieceTexture.atlas = sourceSprite.texture
		pieceTexture.region = Rect2(halfWidth * pieceIndex, 0, halfWidth, textureSize.y)

		var pieceSprite := Sprite2D.new()
		pieceSprite.texture = pieceTexture
		var direction: float = -1.0 if pieceIndex == 0 else 1.0
		pieceSprite.position = sourceSprite.position + Vector2(
			direction * (halfWidth * 0.5 * sourceSprite.scale.x + 4.0),
			0
		)
		pieceSprite.scale = sourceSprite.scale
		pieceSprite.z_index = sourceSprite.z_index
		grabbable.add_child(pieceSprite)

	sourceSprite.hide()
	isChopped = true
	return true
