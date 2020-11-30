extends "res://actor/Enemy/EnemyActor.gd"

# Export
export (NodePath) var patrol_path = ""
export var healing_amount = 20

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
	$Node/Particles2D.global_rotation = 0
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
		position = patrol_points[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(_delta):
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
#		if target_list.size() > 0:
#			var desired_direction = (target_list[0].global_position - global_position).normalized() * delta
#			$Canon.global_rotation = desired_direction.angle() + 1.57
#			pass
#		else:
#			$Canon.global_rotation = global_rotation + 1.57
		
	else:
		move_and_slide(Vector2(0,0))
	pass

func _on_ShotTimer_timeout():
	$Node/Particles2D.global_position = global_position
	$Node/Particles2D.emitting = true
	$Node/Particles2D.restart()
	$Node/Particles2D2.global_position = global_position
	$Node/Particles2D2.emitting = true
	$Node/Particles2D2.restart()
	var overlapping_areas = $EnemyDetection.get_overlapping_bodies()
	for area in overlapping_areas:
		area.modify_health(healing_amount)
	#$AudioStreamPlayer2D.play()
	pass # Replace with function body.





# NOT USED FUNCTIONS

func _on_EnemyDetection_area_entered(_area):
	pass # Replace with function body.

func _on_EnemyDetection_area_exited(_area):
	pass # Replace with function body.

func _on_EnemyDetection_body_entered(_body):
	pass # Replace with function body.

func _on_EnemyDetection_body_exited(_body):
	pass # Replace with function body.

func on_enemy_died(_enemy):
	pass
