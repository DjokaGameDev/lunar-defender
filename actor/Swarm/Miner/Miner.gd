extends "res://actor/Swarm/SwarmActor.gd"

# Speed at which the laser extends when first fired, in pixels per seconds.
export var cast_speed := 7000.0
# Base duration of the tween animation in seconds.
export var growth_time := 0.1

var collecting = false

# Called when the node enters the scene tree for the first time.
func specific_ready():
	global_position = get_tree().get_root().get_node_or_null("BattleField/GroundObject/PlayerCore").global_position
	yield($AnimationPlayer,"animation_finished")
	set_process(true)
	#$ShotTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(delta):
	if target != null:
		var dist = target.global_position.distance_to(global_position) - stop_distance
		var turn_around = Vector2(0,0)
		if dist < 200:
			turn_around = Vector2(0,1) * turning_speed * delta
			if not collecting:
				start_collecting()
		var current_speed = min(speed, dist*50)
		#if dist < 0:
			#current_speed = 1
		var desired_direction = (target.global_position - global_position).normalized() * current_speed * delta
		if dist < 0:
			global_rotation = desired_direction.angle() - PI
		else:
			global_rotation = desired_direction.angle()
		
		#print("start" + str(global_rotation))
		#print(turn_around)
		turn_around = turn_around.rotated(global_rotation)
		#print(turn_around)
		move_and_slide(desired_direction+turn_around)
	else:
		var desired_direction = (parent_tower.global_position - global_position).normalized() * speed * delta
		global_rotation = desired_direction.angle()
		#laser.global_rotation = $Canon.global_rotation - 1.57
		#global_position = global_position
		move_and_slide(desired_direction)
		if parent_tower.global_position.distance_to(global_position) < 1:
			emit_signal("landed")
			queue_free()
			pass
	
	$Laser.points[1] = to_local(target.global_position)
	$Particles2D3.position = to_local(target.global_position) * 0.5
	$Particles2D3.process_material.emission_box_extents.x = Vector2(0,0).distance_to(to_local(target.global_position)) * 0.5
	$Particles2D4.position = to_local(target.global_position)
	pass

func start_collecting():
	$Laser.visible = true
	$Particles2D2.emitting = true
	$Particles2D2.restart()
	$Particles2D3.emitting = true
	$Particles2D3.restart()
	$Particles2D4.emitting = true
	$Particles2D4.restart()
	collecting = true
	$CollectingTimer.start()
	$AudioStreamShot.play()
	pass

func stop_collecting():
	$Laser.visible = false
	$Particles2D2.emitting = false
	$Particles2D3.emitting = false
	$Particles2D4.emitting = false
	collecting = false
	$CollectingTimer.stop()
	$AudioStreamShot.stop()
	pass

func _on_ShotTimer_timeout():
	pass


func _on_CollectingTimer_timeout():
	if collecting:
		var new_gold = harvestable.instance()
		new_gold.global_position = global_position
		new_gold.value = 25
		get_parent().get_parent().add_child(new_gold)
		pass
	pass # Replace with function body.
