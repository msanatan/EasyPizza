class_name IngredientsContainer
extends Node2D

@export var resources_path: String = "res://ingredients/variations/"
@export var ingredient_scene: PackedScene
enum Difficuluty {NORMAL, HARD}
@export var mode: Difficuluty
@export var ingredient_size = 196
@export var row_size = 3

var ingredient_data: Array[IngredientData] = []
var ingredients: Array[BaseIngredient] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	ingredient_data = load_resources_from_path()
	ingredient_data.shuffle()
	setup_ingredients()


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
		add_child(ingredient)
		ingredients.append(ingredient)


func load_resources_from_path() -> Array[IngredientData]:
	var loaded_data: Array[IngredientData] = []
	var dir = DirAccess.open(resources_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				#loaded_data.append(ResourceLoader.load(resources_path + file_name, "IngredientData"))
				loaded_data.append(load(resources_path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred trying to read the ingredients")
	return loaded_data


func _process(delta):
	pass
