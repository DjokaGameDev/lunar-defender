extends "res://actor/Enemy/EnemyActor.gd"

# Exports

# Signals

# Variables
var move_speed = 6000.0
var min_move_speed = 3000.0
var rotation_speed = 2.0
var distance_after_target = 200
var target_position = Vector2(0.0,0.0)
var current_speed = min_move_speed
var lerp_ratio = 0.05

var LaserClass = preload("res://actor/Enemy/tank1/Laser.tscn")

# Called when the node enters the scene tree for the first time.
func specific_ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(delta):
	if get_tree().get_root().get_node_or_null("BattleField/GroundObject/PlayerCore") != null:
		target_position = get_tree().get_root().get_node("BattleField/GroundObject/PlayerCore").global_position
		#var desired_direction = (target_position - global_position).normalized()
		var local_direction = to_local(target_position).normalized()
		#print("local direction " + str(local_direction))
		if local_direction.x > 0.7:
			# Target in front
			#print(" " + str(min_move_speed) + " " + str(move_speed) + " " + str(global_position.distance_to(target_position)))
			#print(str(min(move_speed, global_position.distance_to(target_position) * 20.0)) + " " + str(max(min_move_speed, min(move_speed, global_position.distance_to(target_position) * 20.0))))
			current_speed = lerp(current_speed, max(min_move_speed, min(move_speed, global_position.distance_to(target_position) * 20.0)), lerp_ratio)
			
			if local_direction.angle() > 0.05:
				global_rotation = global_rotation + rotation_speed * delta
			elif local_direction.angle() < -0.05:
				global_rotation = global_rotation - rotation_speed * delta
			else:
				pass
			pass
		else:
			# Target not in front
			if global_position.distance_to(target_position) > distance_after_target:
				current_speed = lerp(current_speed, min_move_speed, lerp_ratio)
				if local_direction.angle() > 0.05:
					global_rotation = global_rotation + rotation_speed * delta
				elif local_direction.angle() < -0.05:
					global_rotation = global_rotation - rotation_speed * delta
				else:
					pass
			else:
				current_speed = lerp(current_speed, move_speed*2.0, lerp_ratio)
			pass
		
		#desired_direction = desired_direction.clamped(global_position.distance_to(target_position) - 200)
		#global_position = global_position + desired_direction
		move_and_slide(Vector2(1,0).rotated(global_rotation)*current_speed * delta)
		
		#global_rotation = desired_direction.angle()
	pass

func _on_ShotTimer_timeout():
	if target_list.size() > 0:
		var local_direction = to_local(target_position).normalized()
		if local_direction.x > 0.7:
			# Shot laser
			var laser = LaserClass.instance()
			# Direction of canon
			laser.global_rotation = global_rotation
			laser.global_position = global_position
			
			get_node("..").add_child(laser)
			
			$AudioStreamPlayer2D.play()
		pass
	pass # Replace with function body.
