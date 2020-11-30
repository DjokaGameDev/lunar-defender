extends Area2D

var speed = 500.0
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2(speed*delta,0).rotated(global_rotation))
	pass


func _on_Laser_area_entered(area):
	if area.is_in_group("tower_building"):
		speed = 0.0
		area.get_parent().modify_health(-damage)
		queue_free()
	pass # Replace with function body.


func _on_Laser_body_entered(body):
	if body.is_in_group("swarm"):
		speed = 0.0
		body.modify_health(-damage)
		queue_free()
	pass # Replace with function body.


func _on_DestroyTimer_timeout():
	queue_free()
	pass # Replace with function body.
