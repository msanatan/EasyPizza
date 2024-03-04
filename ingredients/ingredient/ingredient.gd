class_name Ingredient
extends Area2D

signal ingredient_selected

@export var texture: Texture2D
@export var ingredient_name: String
@export var is_playing: bool = false

@onready var cover_sprite: Sprite2D = $CoverSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture
	cover_sprite.hide()


func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if is_playing and event.is_action_pressed("click"):
		cover_sprite.hide()
		emit_signal("ingredient_selected", ingredient_name)


## Toggle whether the ingredients are visible or covered
func set_is_playing(value: bool) -> void:
	if value:
		cover_sprite.show()
		is_playing = true
	else:
		cover_sprite.hide()
		is_playing = false


## Hide ingredient after the round is over
func hide_ingredient() -> void:
	cover_sprite.show()
