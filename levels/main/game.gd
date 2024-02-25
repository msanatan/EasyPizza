class_name Game
extends Node2D

enum Difficuluty {NORMAL, HARD}

@export var resources_path: String = "res://ingredients/variations/"
@export var ingredient_scene: PackedScene
@export var mode: Difficuluty
@export var ingredient_size = 196
@export var row_size = 3

@onready var ingredients_container = $IngredientsContainer

var ingredient_data: Array[IngredientData] = []
var selected_ingredients: Array[BaseIngredient] = []

func _ready():
	randomize()
	ingredient_data = load_resources_from_path()
	ingredient_data.shuffle()
	setup_ingredients()


## Instiante ingredient scenes and adds them to the game
func setup_ingredients():
	var limit = 6 if mode == Difficuluty.NORMAL else 9
	var start_position = position - Vector2(ingredient_size, 0)
	var rows: int = limit / row_size
	for i in range(ingredient_data.size()):
		if i >= limit:
			break

		var x_offset = (i % row_size) * ingredient_size
		var y_offset = (i / row_size) * ingredient_size
		var ingredient: BaseIngredient = ingredient_scene.instantiate()
		ingredient.texture = ingredient_data[i].texture
		ingredient.ingredient_name = ingredient_data[i].name
		ingredient.position = start_position + Vector2(x_offset, y_offset)
		ingredients_container.add_child(ingredient)
		selected_ingredients.append(ingredient)


## Loads the ingredients from the file system
func load_resources_from_path() -> Array[IngredientData]:
	var loaded_data: Array[IngredientData] = []
	var dir = DirAccess.open(resources_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				loaded_data.append(load(resources_path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred trying to read the ingredients")
	return loaded_data


## This function returns a random selection of pizza ingredients.
## The pizza should be able to use ingredients that are available to the player.
func get_random_ingredient_data(num_ingredients: int) -> Array[BaseIngredient]:
	var chosen_ingredients = []
	while chosen_ingredients.size() < num_ingredients:
		var sid = selected_ingredients.pick_random()
		var already_selected = false
		for ci in chosen_ingredients:
			if ci.name == sid.name:
				already_selected = true
				break
		if not already_selected:
			chosen_ingredients.append(sid)
	return chosen_ingredients
