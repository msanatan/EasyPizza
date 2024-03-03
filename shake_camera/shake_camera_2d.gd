class_name ShakeCamera2D
extends Camera2D

# Taken from Kids can Code Godot 3 tutorial: https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

## How quickly shaking will stop [0,1].
@export_range(0, 1) var decay = 0.8
## Maximum displacement in pixels.
@export var max_offset: Vector2 = Vector2(100,75)
## Maximum rotation in radians (use sparingly).
@export var max_roll: float = 0.1
## The source of random values.
@export var noise: FastNoiseLite

var noise_y = 0 # Value used to move through the noise
var trauma:= 0.0 # Current shake strength
var trauma_pwr:= 3 # Trauma exponent. Use [2,3]

func _ready():
	randomize()
	noise.seed = randi()


func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)


func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func shake() -> void: 
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(noise.seed,noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(noise.seed*2,noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(noise.seed*3,noise_y)
