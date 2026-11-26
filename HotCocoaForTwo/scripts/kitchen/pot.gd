class_name Pot
extends RigidBody2D

# Use this later for sounds effects, recipe checkers, etc.
signal ingredient_added(type: Ingredient.Type, total: int)
# Used when the pot reaches its max size
signal pot_full

# The most ingredients the pot will accept
@export var max_ingredients: int = 3
# Add pot sprites here
# Slot 0 = empty pot, slot 1 = one ingredient, slot 2 = two ingredients...
@export var fill_textures: Array[Texture2D] = []
# This section is used for testing purposes since I don't have sprites
# Which color each ingredient gives the pot
const INGREDIENT_COLORS: Dictionary = {
	Ingredient.Type.CHOCOLATE: Color(0.45, 0.25, 0.10),
	Ingredient.Type.MILK: Color(1.0, 0.97, 0.85),
	Ingredient.Type.MARSHMALLOW: Color(1.0, 0.65, 0.80)
}
@onready var sprite: Sprite2D = $Sprite2D
@onready var drop_area: Area2D = $DropArea
# Every ingredient that has been added to the pot is stored here
var contents: Array[Ingredient.Type] = []

# Runs once, when the pot first appears in the game
func _ready() -> void:
	update_look() # make sure the pot starts out looking empty

func _physics_process(_delta: float) -> void:
	for area in drop_area.get_overlapping_areas():
		# Figure out which Ingredient (if any) this area belongs to
		var ingredient: Ingredient = find_ingredient(area)
		if ingredient == null:
			continue
		# Ignore ingredients the player is still holding and the one just dropped
		if ingredient.isGrabbed or ingredient.is_used:
			continue
		# Try to add the ingredient to the pot
		if add_ingredient(ingredient):
			ingredient.use_up() # the ingredient disappears from the game

# Find the node that has the Ingredient script on it. Returns null if there isn't one
func find_ingredient(area: Area2D) -> Ingredient:
	var node: Node = area.get_parent()
	while node != null:
		if node is Ingredient:
			return node as Ingredient
		node = node.get_parent()
	return null

# Try to put an ingredient in the pot
func add_ingredient(ingredient: Ingredient) -> bool:
	if is_full():
		return false
	contents.append(ingredient.type)
	update_look()
	ingredient_added.emit(ingredient.type, contents.size())
	# Debug line for testing (since we don't have recipes yet)
	print("Pot now contains: ", get_contents_as_text())
	if is_full():
		pot_full.emit()
	return true

# Used to check if the pot is full
func is_full() -> bool:
	return contents.size() >= max_ingredients

# Used to check how many of one kind of ingredient there is in the pot
func count_of(type: Ingredient.Type) -> int:
	return contents.count(type)

# Used to check if the pot has this certain ingredient
func has_ingredient(type: Ingredient.Type) -> bool:
	return contents.has(type)

# Used to get a copy of the list of everything in the pot
func get_contents() -> Array[Ingredient.Type]:
	return contents.duplicate()

# Used to get the contents as readable text, like "CHOCOLATE, MILK"
func get_contents_as_text() -> String:
	var names: Array[String] = []
	for type in contents:
		names.append(Ingredient.Type.keys()[type])
	return ", ".join(names)

# Used to empty the pot and its contents
func empty_pot() -> void:
	contents.clear()
	update_look()

# Updates the pot's appearance to match what is inside it
func update_look() -> void:
	# Use this option only if someone filled in "Fill Textures" with sprites
	if not fill_textures.is_empty():
		var index: int = mini(contents.size(), fill_textures.size() - 1)
		if fill_textures[index] != null:
			sprite.texture = fill_textures[index]
		sprite.modulate = Color.WHITE
		return
	# Use this option to test the pot with colors
	if contents.is_empty():
		sprite.modulate = Color.WHITE
		return
	# Mix the colors of everything inside by averaging them
	var total := Color(0, 0, 0, 0)
	for type in contents:
		total += INGREDIENT_COLORS.get(type, Color.GRAY)
	var average_color: Color = total / contents.size()
	# The fuller the pot, the stronger the color
	var fullness: float = float(contents.size()) / float(max_ingredients)
	sprite.modulate = Color.WHITE.lerp(average_color, fullness)
