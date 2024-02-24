class_name BaseIngredient
extends Area2D

@export var texture: Texture2D
@export var ingredient: String
@export var is_playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if is_playing and (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		print("Sprite touched")
