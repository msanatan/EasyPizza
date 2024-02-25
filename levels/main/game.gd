class_name Game
extends Node2D

enum Difficuluty {NORMAL, HARD}
enum GameState {READY, PLAYING, ROUND_OVER}

@export var resources_path: String = "res://ingredients/variations/"
@export var ingredient_scene: PackedScene
@export var mode: Difficuluty
@export var ingredient_size = 196
@export var row_size = 3

@onready var ingredients_container: Node2D = $IngredientsContainer
@onready var ready_label: Label = $HUD/ReadyLabel

var current_state: GameState = GameState.READY
var ingredient_data: Array[IngredientData] = []
var available_ingredients: Array[Ingredient] = []
var available_ingredient_data: Array[IngredientData] = []
var current_ingredeints: Array[IngredientData] = []
var pizzas: Array[Pizza]
var current_pizza: Pizza


func _ready():
	randomize()
	ingredient_data = load_resources_from_path()
	ingredient_data.shuffle()
	setup_ingredients()
	setup_pizzas()


func _input(event):
	if current_state == GameState.READY and Input.is_action_just_pressed("click"):
		current_state = GameState.PLAYING
		ready_label.hide()
		# Make every ingredient active so they can react to the user selection
		for ingredient in available_ingredients:
			ingredient.set_is_playing(true)
		begin_round()


## 
func begin_round() -> void:
	current_ingredeints = get_random_ingredient_data(1)
	current_pizza.add_toppings(current_ingredeints)
	current_pizza.enter_scene()


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
		var ingredient: Ingredient = ingredient_scene.instantiate()
		ingredient.texture = ingredient_data[i].container_texture
		ingredient.ingredient_name = ingredient_data[i].name
		ingredient.position = start_position + Vector2(x_offset, y_offset)
		ingredients_container.add_child(ingredient)
		available_ingredients.append(ingredient)
		available_ingredient_data.append(ingredient_data[i])


## Load pizzas and make the first one the active one
## We're managing 2 pizzas so as the user gets one correct/wrong,
## When it's leaving the screen, the new one is coming into the screen
func setup_pizzas():
	var children = $PizzaPool.get_children()
	for child in children:
		pizzas.append(child as Pizza)
	current_pizza = pizzas[0]


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
func get_random_ingredient_data(num_ingredients: int) -> Array[IngredientData]:
	var chosen_ingredients: Array[IngredientData] = []
	while chosen_ingredients.size() < num_ingredients:
		var sid = available_ingredient_data.pick_random()
		var already_selected = false
		for ci in chosen_ingredients:
			if ci.name == sid.name:
				already_selected = true
				break
		if not already_selected:
			chosen_ingredients.append(sid)
	return chosen_ingredients
