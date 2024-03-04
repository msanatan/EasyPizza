extends Node2D

## Length of time logo should be visible
@export var logo_duration: float = 2.0
@export var next_scene: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var fade_in = true

func _ready():
	animation_player.play("fade")

func _on_animation_player_animation_finished(_anim_name: String):
	if fade_in:
		# Show the logo for some time
		await get_tree().create_timer(logo_duration).timeout
		fade_in = false
		animation_player.play_backwards("fade")
	else:
		get_tree().change_scene_to_packed(next_scene)
