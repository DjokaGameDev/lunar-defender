extends "res://actor/Swarm/SwarmActor.gd"

var HealingBeamClass = preload("res://actor/Enemy/tankheal/HealingBeam.tscn")
var sorted_enemies = []
var current_beams = []

func specific_process(delta):
	if parent_tower.sorted_enemies.size() > 0:
		var dist = parent_tower.sorted_enemies[0].global_position.distance_to(global_position) - stop_distance
		var turn_around = Vector2(0,0)
		if dist < 200:
			turn_around = Vector2(0,1) * turning_speed * delta
		var current_speed = min(speed, dist*50)
		#if dist < 0:
			#current_speed = 1
		var desired_direction = (parent_tower.sorted_enemies[0].global_position - global_position).normalized() * current_speed * delta
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
		if parent_tower.global_position.distance_to(global_position) < 2:
			emit_signal("landed")
			queue_free()
			pass
	pass
	
func _on_ShotTimer_timeout():
	
#	sorted_enemies.clear()
#	for enemy in parent_tower.enemy_collision_list:
#		if target.is_in_group("swarm"):
#			if enemy.health < enemy.starting_health and enemy != self:
#				sorted_enemies.push_back(enemy)
#				pass
#		else:
#			if enemy.get_parent().health < enemy.get_parent().starting_health:
#				sorted_enemies.push_back(enemy)
#				pass
#		pass
		
	stop_healing()
	start_healing()
	pass
	
	
func start_healing():
	var heal = null
	for enemy in parent_tower.sorted_enemies:
		if enemy != null:
			if enemy.global_position.distance_to(global_position) < 200:
				heal = HealingBeamClass.instance()
				heal.target = enemy
				add_child(heal)
				current_beams.push_back(heal)
	pass
	
func stop_healing():
	for beams in current_beams:
		var is_present = current_beams.find(beams)
		if is_present != -1:
			current_beams[is_present].queue_free()
			current_beams.remove(is_present)
	pass
