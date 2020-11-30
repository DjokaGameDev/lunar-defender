extends "res://actor/Swarm/SwarmActor.gd"

var ThunderClass = preload("res://actor/Swarm/ThunderSwarm/ThunderBolt.tscn")

var patrol_points
var global_patrol_points = []
var patrol_index = 0
var move_speed = 100
var id = 2

func specific_ready():
	patrol_points = parent_tower.get_node("Path2D"+str(id)).curve.get_baked_points()
	for points in patrol_points:
		global_patrol_points.push_back(to_global(points))
		pass
	patrol_index = patrol_points.size()-1
	global_position = global_patrol_points[patrol_index]
	
	
	turning_speed = rand_range(turning_speed-500, turning_speed+500) * (((randi() % 2) * 2) - 1)
	stop_distance = rand_range(stop_distance, stop_distance+20)
	set_process(true)
	yield($AnimationPlayer,"animation_finished")
	$ShotTimer.start()
	pass
	
func _on_ShotTimer_timeout():
	
	if target != null:
		var thunder = ThunderClass.instance()
		thunder.bouncing_number = 2
		get_parent().add_child(thunder)
		thunder.create(global_position, target)
		$AudioStreamShot.play()
	
	pass

func specific_process(delta):
	if swarm_state == SWARM_TAKING_OFF:
		var target_path = global_patrol_points[patrol_index]
		if global_position.distance_to(target_path) < 2:
			patrol_index = wrapi(patrol_index - 1, 0, global_patrol_points.size())
			target_path = global_patrol_points[patrol_index]
			if patrol_index == (1):
				patrol_index = 0
				flying()
		var velocity = (target_path - global_position).normalized() * move_speed
		global_rotation = velocity.angle()
		#current_velocity = lerp(current_velocity, velocity, 0.5)
		#current_velocity = move_and_slide(current_velocity)
		move_and_slide(velocity)
		pass
	elif swarm_state == SWARM_FLYING:
		if target != null:
			var dist = target.global_position.distance_to(global_position) - stop_distance
			var turn_around = Vector2(0,0)
			if dist < 200:
				turn_around = Vector2(0,1) * turning_speed * delta
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
			var desired_direction = (global_patrol_points[patrol_index] - global_position).normalized() * speed * delta
			global_rotation = desired_direction.angle()
			#laser.global_rotation = $Canon.global_rotation - 1.57
			#global_position = global_position
			move_and_slide(desired_direction)
			if global_patrol_points[patrol_index].distance_to(global_position) < 2:
				landing()
				#emit_signal("landed")
				#queue_free()
				pass
	elif swarm_state == SWARM_LANDING:
		var target_path = global_patrol_points[patrol_index]
		if global_position.distance_to(target_path) < 2:
			patrol_index = wrapi(patrol_index + 1, 0, global_patrol_points.size())
			target_path = global_patrol_points[patrol_index]
			if patrol_index == (global_patrol_points.size() - 1):
				patrol_index = 0
				emit_signal("landed")
				queue_free()
		var velocity = (target_path - global_position).normalized() * move_speed
		global_rotation = velocity.angle()
		#current_velocity = lerp(current_velocity, velocity, 0.5)
		#current_velocity = move_and_slide(current_velocity)
		move_and_slide(velocity)
		pass
	pass

func flying():
	z_index = 0
	swarm_state = SWARM_FLYING
	pass
	
func landing():
	#z_index = -1
	swarm_state = SWARM_LANDING
	$AnimationPlayer.play("landing")
	#yield($AnimationPlayer,"animation_finished")
	pass
