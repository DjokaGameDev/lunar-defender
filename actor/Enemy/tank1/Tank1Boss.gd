extends "res://actor/Enemy/EnemyActor.gd"

# Export
export (NodePath) var patrol_path = ""

# Signal

# Variables
var LaserClass = preload("res://actor/Enemy/tank1/Laser.tscn")
#var TrackClass = preload("res://effects/TrackParticle/TrackParticle.tscn")
#var TrackClass = preload("res://effects/TrackParticle/TrackParticleSprite.tscn")
var TrackClass = preload("res://effects/TrackParticle/TrackLine.tscn")
var move_speed = 70
var patrol_points
var patrol_index = 0
var current_patrol_path = 0

var counter = 0

# Called when the node enters the scene tree for the first time.
func specific_ready():
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
		position = patrol_points[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(delta):
#	counter = counter + 1 
#	if counter > 12:
#		counter = 0
	if health > 0:
		# Moving
		if !patrol_path:
			return
		var target = patrol_points[patrol_index]
		if position.distance_to(target) < 1:
			patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
			target = patrol_points[patrol_index]
			if current_patrol_path == 0 and patrol_index == (patrol_points.size() - 1):
				patrol_index = 0
				patrol_points = get_node("../../CircularPath").curve.get_baked_points()
				current_patrol_path = 1
		var velocity = (target - position).normalized() * move_speed
		global_rotation = velocity.angle()
		current_velocity = lerp(current_velocity, velocity, 0.5)
		current_velocity = move_and_slide(current_velocity)
		
		# Target and shot
		if target_list.size() > 0:
			var desired_direction = (target_list[0].global_position - global_position).normalized() * delta
			$Gun_02.global_rotation = desired_direction.angle() + 1.57
			$Gun_03.global_rotation = $Gun_02.global_rotation
			$Gun_04.global_rotation = $Gun_02.global_rotation
			$Gun_05.global_rotation = $Gun_02.global_rotation
			pass
		else:
			$Gun_02.global_rotation = global_rotation + 1.57
			$Gun_03.global_rotation = global_rotation + 1.57
			$Gun_04.global_rotation = global_rotation + 1.57
			$Gun_05.global_rotation = global_rotation + 1.57
		
	else:
		move_and_slide(Vector2(0,0))
	pass

func _on_ShotTimer_timeout():
	if target_list.size() > 0:
		var desired_direction = (target_list[0].global_position - global_position).normalized()
		$Gun_02.global_rotation = desired_direction.angle() + 1.57
		$Gun_03.global_rotation = $Gun_02.global_rotation
		$Gun_04.global_rotation = $Gun_02.global_rotation
		$Gun_05.global_rotation = $Gun_02.global_rotation
		# Shot laser
		var laser = LaserClass.instance()
		# Direction of canon
		laser.global_rotation = $Gun_02.global_rotation - 1.57
		laser.global_position = $Gun_02.global_position
		
		get_node("..").add_child(laser)
		
		laser = LaserClass.instance()
		# Direction of canon
		laser.global_rotation = $Gun_03.global_rotation - 1.57
		laser.global_position = $Gun_03.global_position
		
		get_node("..").add_child(laser)
		
		laser = LaserClass.instance()
		# Direction of canon
		laser.global_rotation = $Gun_04.global_rotation - 1.57
		laser.global_position = $Gun_04.global_position
		
		get_node("..").add_child(laser)
		
		laser = LaserClass.instance()
		# Direction of canon
		laser.global_rotation = $Gun_05.global_rotation - 1.57
		laser.global_position = $Gun_05.global_position
		
		get_node("..").add_child(laser)
		
		#$AudioStreamPlayer2D.play()
		pass
	else:
		$Gun_02.global_rotation = global_rotation + 1.57
		$Gun_03.global_rotation = global_rotation + 1.57
		$Gun_04.global_rotation = global_rotation + 1.57
		$Gun_05.global_rotation = global_rotation + 1.57
		
	
	pass # Replace with function body.


func _on_TrackTimer_timeout():
	var track = TrackClass.instance()
	track.global_position = global_position + Vector2(0,7).rotated(global_rotation)
	track.global_rotation = global_rotation + 1.57
	get_parent().add_child(track)
	track.get_node("AnimationPlayer").play("disapear")

	track = TrackClass.instance()
	track.global_position = global_position + Vector2(0,-7).rotated(global_rotation)
	track.global_rotation = global_rotation + 1.57
	get_parent().add_child(track)
	track.get_node("AnimationPlayer").play("disapear")
	pass # Replace with function body.
