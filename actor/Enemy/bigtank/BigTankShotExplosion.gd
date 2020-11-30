extends Area2D

export var damage = 50

var process_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	process_number = process_number + 1
	
	if process_number > 10:
		var overlapping_bodies = get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("swarm"):
				body.modify_health(-damage)
		var overlapping_areas = get_overlapping_areas()
		for area in overlapping_areas:
			if area.is_in_group("tower_building"):
				area.get_parent().modify_health(-damage)
		queue_free()
	pass
