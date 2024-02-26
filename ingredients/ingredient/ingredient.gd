class_name Ingredient
extends Area2D

signal ingredient_selected

@export var texture: Texture2D
@export var ingredient_name: String
@export var is_playing: bool = false

@onready var cover_sprite: Sprite2D = $CoverSprite
@onready var after_click_timer: Timer = $AfterClickTimer
var input_lock: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture
	cover_sprite.hide()


func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if is_playing and not input_lock and event.is_action_pressed("click"):
		input_lock = true
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
	input_lock = false
