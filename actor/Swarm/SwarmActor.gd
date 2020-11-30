extends KinematicBody2D

# Export
export var starting_health = 50
export var speed = 5000
export var turning_speed = 2000
export var stop_distance = 50

# Signal
signal landed
signal died(actor)

# Variables
var LaserClass = preload("res://actor/Swarm/Laser.tscn")
var explosion = preload("res://effects/SmallExplosion/SmallExplosion.tscn")
var harvestable = preload("res://level/Battlefield/HarvestableRessource.tscn")
var health = 0.0
var parent_tower = null
var target = null

enum {
	SWARM_TAKING_OFF,
	SWARM_FLYING,
	SWARM_LANDING
}
var swarm_state = SWARM_TAKING_OFF

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("swarm")
	health = starting_health
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	set_process(false)
	$AnimationPlayer.play("takeoff")
	$AudioStreamTakeOff.play()
	randomize()
	
	#print(turning_speed)
	specific_ready()
	pass # Replace with function body.

func specific_ready():
	turning_speed = rand_range(turning_speed-500, turning_speed+500) * (((randi() % 2) * 2) - 1)
	stop_distance = rand_range(stop_distance, stop_distance+20)
	yield($AnimationPlayer,"animation_finished")
	set_process(true)
	$ShotTimer.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GUI.global_rotation = 0
	specific_process(delta)
	pass
	
func specific_process(delta):
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
		var desired_direction = (parent_tower.global_position - global_position).normalized() * speed * delta
		global_rotation = desired_direction.angle()
		#laser.global_rotation = $Canon.global_rotation - 1.57
		#global_position = global_position
		move_and_slide(desired_direction)
		if parent_tower.global_position.distance_to(global_position) < 2:
			landing()
			emit_signal("landed")
			queue_free()
			pass
	pass

func flying():
	swarm_state = SWARM_FLYING
	pass
	
func landing():
	swarm_state = SWARM_LANDING
	$AnimationPlayer.play("landing")
	yield($AnimationPlayer,"animation_finished")
	pass

func modify_health(value):
	health = health + value
	$GUI/LifeBar.value = health
	if value < 0:
		$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(0, 0, 0, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.interpolate_property($Sprite, "modulate", Color(0, 0, 0, 1), Color(1, 1, 1, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.05)
		$Tween.start()
	if health <= 0:
		emit_signal("died", self)
		destroy_instance()
	pass

func destroy_instance():
	var explo = explosion.instance()
	explo.global_position = global_position
	get_parent().add_child(explo)
	explo.get_node("AnimationPlayer").play("explosion")
	EventBus.emit_signal("shake_camera", 0.1)
	
	call_deferred("drop_gold")
	
	queue_free()
	pass
	
func drop_gold():
	var new_gold = harvestable.instance()
	new_gold.global_position = global_position
	new_gold.value = 5
	get_tree().get_root().get_node_or_null("BattleField/GroundObject").add_child(new_gold)

func _on_ShotTimer_timeout():
	if target != null:
		# Shot laser
		var laser = LaserClass.instance()
		# Direction of canon
		#var desired_direction = (target.global_position - global_position).normalized()
		laser.global_rotation = global_rotation#desired_direction.angle()
		#laser.global_rotation = $Canon.global_rotation - 1.57
		laser.global_position = global_position
		$AudioStreamShot.pitch_scale = rand_range(0.8,1.2)
		$AudioStreamShot.play()
		
		get_node("..").add_child(laser)
		pass
	pass # Replace with function body.

func change_target(new_target):
	#print(new_target)
	target = new_target
	pass

func parent_died(_parent):
	queue_free()
	pass
