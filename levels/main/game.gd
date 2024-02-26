class_name Game
extends Node2D

enum Difficuluty {NORMAL, HARD}
enum GameState {READY, PLAYING, ROUND_OVER}

@export var resources_path: String = "res://ingredients/variations/"
@export var ingredient_scene: PackedScene
@export var mode: Difficuluty
@export var ingredient_size = 256
@export var row_size = 3
@export var score_increment = 5
@export var round_duration_seconds = 60

@onready var ingredients_container: Node2D = $IngredientsContainer
@onready var ready_label: Label = $HUD/ReadyLabel
@onready var score_label: Label = $HUD/ScoreLabel
@onready var time_remaining_label: Label = $HUD/TimeRemainingLabel
@onready var game_timer: Timer = $GameTimer

var current_state: GameState = GameState.READY
var score = 0
var ingredient_data: Array[IngredientData] = []
var available_ingredients: Array[Ingredient] = []
var available_ingredient_data: Array[IngredientData] = []
var current_ingredients: Array[IngredientData] = []
var already_guessed_ingredients: Array[String] = []
var pizzas: Array[Pizza]
var current_pizza_index: int
var remaining_guesses: int
var remaining_time: int


func _ready():
	randomize()
	ingredient_data = load_resources_from_path()
	ingredient_data.shuffle()
	setup_ingredients()
	setup_pizzas()


func _input(event):
	if current_state == GameState.READY and Input.is_action_just_pressed("click"):
		current_state = GameState.PLAYING
		# Make every ingredient active so they can react to the user selection
		for ingredient in available_ingredients:
			ingredient.set_is_playing(true)
		remaining_time = round_duration_seconds
		game_timer.start()
		ready_label.hide()
		score_label.text = "Score: %d" % score
		score_label.show()
		time_remaining_label.show()
		begin_round()


## Gets the ingredients to be guessed
func begin_round() -> void:
	already_guessed_ingredients = []
	current_ingredients = get_random_ingredient_data(1)
	remaining_guesses = current_ingredients.size()
	pizzas[current_pizza_index].add_toppings(current_ingredients)
	pizzas[current_pizza_index].enter_scene()


## Move the current pizza off and start a new round
func end_round() -> void:
	pizzas[current_pizza_index].exit_scene()
	current_pizza_index = (current_pizza_index + 1) % 2
	begin_round()


## Instantiante ingredient scenes and adds them to the game
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
		ingredient.connect("ingredient_selected", check_ingredient_selection)
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
	current_pizza_index = 0


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


## When a user selects and ingredient, check if it was correct or wrong
## We add points to their score if correct, and give them feedback
## If they ran out of guesses, we go to the next round
func check_ingredient_selection(ingredient_name: String) -> void:
	var is_correct = false
	for ingredient in current_ingredients:
		if ingredient.name == ingredient_name and not already_guessed_ingredients.has(ingredient_name):
			is_correct = true
			already_guessed_ingredients.append(ingredient_name)
			break

	if is_correct:
		print("Found a matching ingredient! New score is %d" % score)
		score += score_increment
		score_label.text = "Score: %d" % score
	else:
		print("%s is not on the pizza! New score is %d" % [ingredient_name, score])

	remaining_guesses -= 1
	if remaining_guesses == 0:
		end_round()


func _on_game_timer_timeout():
	remaining_time -= 1
	time_remaining_label.text = "Time Remaining: %d" % remaining_time

	if remaining_time == 0:
		game_timer.stop()
		current_state = GameState.ROUND_OVER
		for ingredient in available_ingredients:
			ingredient.set_is_playing(false)


## If the user wants to play again, reload the scene
func reload() -> void:
	get_tree().reload_current_scene()
