extends Line2D

var healing_amount = 2
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_rotation = 0
	if target != null:
		points[1] = to_local(target.global_position)
		$Particles2D.position = points[1]
	pass


func _on_HealingTimer_timeout():
	if target != null:
		target.modify_health(healing_amount)
	pass # Replace with function body.
