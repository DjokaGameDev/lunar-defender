extends "res://actor/Swarm/SwarmActor.gd"

# Exports

# Signals

# Variables
var move_speed = 6000.0
var min_move_speed = 3000.0
var rotation_speed = 2.0
var distance_after_target = 100
var target_position = Vector2(0.0,0.0)
var current_speed = min_move_speed
var lerp_ratio = 0.05

var BombClass = preload("res://actor/Swarm/BomberSwarm/BombFromSwarm.tscn")

# Called when the node enters the scene tree for the first time.
func specific_ready():
	if target != null:
		var desired_direction = (target.global_position - global_position).normalized()
		global_rotation = desired_direction.angle()
	$GUI.global_rotation = 0
	$TakeOffBurnParticles.global_rotation = 0
	yield($AnimationPlayer,"animation_finished")
	set_process(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(delta):
	if target != null:
		target_position = target.global_position
		var local_direction = to_local(target_position).normalized()
		var distance = global_position.distance_to(target_position)
		if abs(local_direction.angle()) < PI/4:
			# Target in front
			current_speed = lerp(current_speed, max(min_move_speed, min(move_speed, distance * 20.0)), lerp_ratio)
			
			if local_direction.angle() > 0.05:
				global_rotation = global_rotation + rotation_speed * delta
			elif local_direction.angle() < -0.05:
				global_rotation = global_rotation - rotation_speed * delta
			else:
				pass
			pass
		else:
			# Target not in front
			# Look for another target
			var enemy_found = false
			for enemy in parent_tower.enemy_collision_list:
				if abs(to_local(enemy.global_position).angle()) < 1.0:
					enemy_found = true
					target = enemy
					break
			
			if not enemy_found:
				target = parent_tower.enemy_collision_list[0]
				if distance > distance_after_target:
					current_speed = lerp(current_speed, min_move_speed, lerp_ratio)
					if local_direction.angle() > 0.05:
						global_rotation = global_rotation + rotation_speed * delta
					elif local_direction.angle() < -0.05:
						global_rotation = global_rotation - rotation_speed * delta
					else:
						pass
				else:
					current_speed = lerp(current_speed, move_speed*1.0, lerp_ratio)
				pass
		
		if distance < 200 and $ShotTimer.is_stopped():
			$ShotTimer.start()
		elif distance > 200:
			$ShotTimer.stop()

		move_and_slide(Vector2(1,0).rotated(global_rotation)*current_speed * delta)
		
	else:
		$ShotTimer.stop()
		var desired_direction = (parent_tower.global_position - global_position).normalized() * speed * delta
		global_rotation = desired_direction.angle()

		move_and_slide(desired_direction)
		if parent_tower.global_position.distance_to(global_position) < 2:
			emit_signal("landed")
			queue_free()
			pass
	pass

func _on_ShotTimer_timeout():
	
	var bomb = BombClass.instance()
	bomb.global_position = global_position
	get_parent().add_child(bomb)
	
	pass
