extends Camera2D

const SHAKE_EXPONENT := 1.8

export var decay_rate := 1.0
export var max_offset := Vector2(100.0, 100.0)
export var max_rotation := 0.1

export var shake_amount := 0.0 setget set_shake_amount
var noise_y := 0.0

onready var noise := OpenSimplexNoise.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
	EventBus.connect("shake_camera", self, "set_shake_amount")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.shake_amount -= 1 * delta
	shake()
	
func shake():
	var amount := pow(shake_amount, 1)

	noise_y += 1.0
	rotation = max_rotation * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset = Vector2(
		max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y),
		max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
	)


func set_shake_amount(value):
	if not is_inside_tree():
		yield(self, "ready")
	shake_amount = clamp(value, 0.0, 1.0)
	set_physics_process(shake_amount != 0.0)

