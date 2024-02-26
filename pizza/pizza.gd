class_name Pizza
extends Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var toppings_container = $Toppings

var original_position: Vector2
var toppings: Array[Sprite2D]
var toppings_placeholder_texture: Texture2D

func _ready():
	original_position = position
	toppings_placeholder_texture = toppings_container.get_child(0).texture
	for child in toppings_container.get_children():
		toppings.append(child as Sprite2D)
	

## Show toppings on pizza
func add_toppings(ingredients: Array[IngredientData]) -> void:
	var current_ingredient = 0
	var different_ingredients = ingredients.size()
	for topping in toppings:
		topping.texture = ingredients[current_ingredient].container_texture
		current_ingredient = (current_ingredient + 1) % different_ingredients


## Return the pizza to it's original state after it's used
func reset() -> void:
	position = original_position
	for topping in toppings:
		topping.texture = toppings_placeholder_texture


## Add toppings and bring pizza into the centre
func enter_scene() -> void:
	animation_player.play("pizza_enter_scene")


## Play the exit animation, and eventually reset the pizza
func exit_scene() -> void:
	animation_player.play("pizza_exit_scene")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pizza_exit_scene":
		reset()
