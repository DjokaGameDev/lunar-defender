extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2(900.0*delta,0).rotated(global_rotation))
	pass


#func _on_Laser_area_entered(area):
#	if area.is_in_group("enemy"):
#		area.modify_health(-10)
#		queue_free()
#	pass # Replace with function body.


func _on_Laser_body_entered(body):
	if body.is_in_group("enemy"):
		body.modify_health(-5)
		queue_free()
	pass # Replace with function body.


func _on_DestroyTimer_timeout():
	queue_free()
	pass # Replace with function body.
