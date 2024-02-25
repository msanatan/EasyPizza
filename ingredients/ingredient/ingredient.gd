class_name Ingredient
extends Area2D

@export var texture: Texture2D
@export var ingredient_name: String
@export var is_playing: bool = false

@onready var cover_sprite: Sprite2D = $CoverSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture
	cover_sprite.hide()


func _on_input_event(viewport, event, shape_idx):
	if is_playing and Input.is_action_just_pressed("click"):
		print("Sprite touched")


## Toggle whether the ingredients are visible or covered
func set_is_playing(value: bool) -> void:
	if value:
		cover_sprite.show()
		is_playing = true
	else:
		cover_sprite.hide()
		is_playing = false
