class_name Ingredient
extends Area2D

signal ingredient_selected

@export var texture: Texture2D
@export var ingredient_name: String
@export var is_playing: bool = false

@onready var cover_sprite: Sprite2D = $CoverSprite
@onready var after_click_timer: Timer = $AfterClickTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture
	cover_sprite.hide()


func _on_input_event(viewport, event, shape_idx):
	if is_playing and Input.is_action_just_pressed("click"):
		print("%s was touched" % ingredient_name)
		emit_signal("ingredient_selected", ingredient_name)
		after_click_timer.start()
		cover_sprite.hide()


## Toggle whether the ingredients are visible or covered
func set_is_playing(value: bool) -> void:
	if value:
		cover_sprite.show()
		is_playing = true
	else:
		cover_sprite.hide()
		is_playing = false


func _on_after_click_timer_timeout():
	cover_sprite.show()
	after_click_timer.stop()
