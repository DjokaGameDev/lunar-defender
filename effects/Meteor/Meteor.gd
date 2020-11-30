extends Area2D

export var damage = 30

var explosion = preload("res://effects/BigExplosion/BigExplosion.tscn")
var motion = Vector2(rand_range(-250,250), rand_range(300,500))


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fall")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(motion*delta)
	pass

func compute_damage():
	var explo = explosion.instance()
	explo.global_position = global_position
	get_parent().add_child(explo)
	explo.get_node("AnimationPlayer").play("explosion")
	EventBus.emit_signal("shake_camera", 0.05)
	
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("swarm"):
			body.modify_health(-damage)
		if body.is_in_group("enemy"):
			body.modify_health(-damage)
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("tower_building"):
			area.get_parent().modify_health(-damage)
			
	
	queue_free()
	pass
