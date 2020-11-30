extends "res://actor/Swarm/SwarmActor.gd"

# Export

# Signals 

# Variables
var collected = false
var collected_gold = 0
var path_target = null
var path_index = 0

# Called when the node enters the scene tree for the first time.
func specific_ready():
	global_position = get_tree().get_root().get_node_or_null("BattleField/GroundObject/PlayerCore").global_position
	yield($AnimationPlayer,"animation_finished")
	set_process(true)
	$ShotTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(delta):
	if target != null:
		if collected:
			var dist = parent_tower.global_position.distance_to(global_position)
			var turn_around = Vector2(0,0)
			var current_speed = min(speed, dist*200)
			var desired_direction = (parent_tower.global_position - global_position).normalized() * current_speed * delta
			if dist < 0:
				global_rotation = desired_direction.angle() - PI
			else:
				global_rotation = desired_direction.angle()
			
			turn_around = turn_around.rotated(global_rotation)
			move_and_slide(desired_direction+turn_around)
			
			if parent_tower.global_position.distance_to(global_position) < 3:
				emit_signal("landed")
				#global.gold_ressource = global.gold_ressource + collected_gold
				EventBus.emit_signal("add_gold", collected_gold)
				queue_free()
				pass
			
			pass
		else:
			var dist = target.distance_to(global_position) - stop_distance
			var turn_around = Vector2(0,0)
			if dist < stop_distance:
				turn_around = Vector2(0,1) * turning_speed * delta
			var current_speed = min(speed, dist*200)
			#if dist < 0:
				#current_speed = 1
			var desired_direction = (target - global_position).normalized() * current_speed * delta
			if dist < 0:
				global_rotation = desired_direction.angle() - PI
			else:
				global_rotation = desired_direction.angle()
			
			#print("start" + str(global_rotation))
			#print(turn_around)
			turn_around = turn_around.rotated(global_rotation)
			#print(turn_around)
			move_and_slide(desired_direction+turn_around)
			
			if dist < (stop_distance+1):
				print(path_target)
				print(path_index)
				print(path_target.size())
				if path_index < (path_target.size() - 1):
					# More points in path
					path_index = path_index + 1
					target = path_target[path_index]
				else:
					# Collect done
					collected = true
	else:
		var desired_direction = (parent_tower.global_position - global_position).normalized() * speed * delta
		global_rotation = desired_direction.angle()
		#laser.global_rotation = $Canon.global_rotation - 1.57
		#global_position = global_position
		move_and_slide(desired_direction)
		if parent_tower.global_position.distance_to(global_position) < 1:
			emit_signal("landed")
			#global.gold_ressource = global.gold_ressource + collected_gold
			EventBus.emit_signal("add_gold", collected_gold)
			queue_free()
			pass
	
	pass


func _on_ShotTimer_timeout():
	pass


func _on_AreaCollector_area_entered(area):
	if area.type == global.RESSOURCE_GOLD:
		collected_gold = collected_gold + area.value
		area.queue_free()
		pass
	pass # Replace with function body.
