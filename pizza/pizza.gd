class_name Pizza
extends Sprite2D

@onready var animation_player = $AnimationPlayer

var original_position: Vector2

func _ready():
	original_position = position


## Return the pizza to it's original state after it's used
func reset() -> void:
	position = original_position


## Add toppings and bring pizza into the centre
func enter_scene() -> void:
	animation_player.play("pizza_enter_scene")


## Play the exit animation, and eventually reset the pizza
func exit_scene() -> void:
	animation_player.play("pizza_exit_scene")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pizza_exit_scene":
		reset()
