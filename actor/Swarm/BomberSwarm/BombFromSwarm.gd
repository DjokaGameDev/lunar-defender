extends Area2D

var explosion = preload("res://effects/BigExplosion/BigExplosion.tscn")

var process_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var explo = explosion.instance()
	explo.global_position = global_position
	get_tree().get_root().get_node_or_null("BattleField/GroundObject").add_child(explo)
	explo.get_node("AnimationPlayer").play("explosion")
	
	
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	process_number = process_number + 1
	
	if process_number > 10:
		var overlapping_areas = get_overlapping_bodies()
		for area in overlapping_areas:
			area.modify_health(-20)
		queue_free()
	pass
