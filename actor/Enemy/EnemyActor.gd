extends KinematicBody2D

# Exports
export var starting_health = 100
export(global.enemy_type) var type = global.enemy_type.ENEMY_TANK1

# Signals
signal died(enemy)

# Variables
var explosion = preload("res://effects/SmallExplosion/SmallExplosion.tscn")
var harvestable = preload("res://level/Battlefield/HarvestableRessource.tscn")
var health
var current_velocity = Vector2(0,0)
var target_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.emit_signal("add_enemy", type)
	set_physics_process(false)
	add_to_group("enemy")
	health = starting_health
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	
	yield(get_tree().create_timer(rand_range(0.05,0.5)), "timeout")
	$ShotTimer.start()
	specific_ready()
	set_physics_process(true)
	pass # Replace with function body.

func specific_ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _physics_process(delta):
	$GUI.global_rotation = 0
	specific_process(delta)
	pass
	
func specific_process(_delta):
	pass

func modify_health(value):
	if health > 0:
		health = health + value
		if health > starting_health:
			health = starting_health
		$GUI/LifeBar.value = health
		if value < 0:
			$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(0, 0, 0, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_property(self, "modulate", Color(0, 0, 0, 1), Color(1, 1, 1, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.05)
			$Tween.start()
			pass
		if health <= 0:
			emit_signal("died", self)
			EventBus.emit_signal("shake_camera", 0.1)
			destroy_instance()
	pass
	
func destroy_instance():
	EventBus.emit_signal("remove_enemy", type)
	$ShotTimer.stop()
	collision_layer = 0
	#$CollisionShape2D.disabled = true
	var explo = explosion.instance()
	explo.global_position = global_position
	get_parent().add_child(explo)
	explo.get_node("AnimationPlayer").play("explosion")
	
	if rand_range(0,100) <= 10:
		call_deferred("drop_gold")
	
	$AnimationPlayer.play("destroy")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
	pass

func drop_gold():
	var new_gold = harvestable.instance()
	new_gold.global_position = global_position
	new_gold.value = 20
	get_tree().get_root().get_node_or_null("BattleField/GroundObject").add_child(new_gold)

func _on_EnemyDetection_area_entered(area):
	if area.is_in_group("tower_building") and area.get_parent().actor_enabled:
		var is_present = target_list.find(area)
		if is_present != -1:
			pass
		else:
			target_list.push_back(area)
			area.get_parent().connect("died", self, "on_enemy_died")
	pass # Replace with function body.

func _on_EnemyDetection_area_exited(area):
	#print(area)
	if area.is_in_group("tower_building") and area.get_parent().actor_enabled:
		var is_present = target_list.find(area)
		if is_present != -1:
			area.get_parent().disconnect("died", self, "on_enemy_died")
			target_list.remove(is_present)
#			if target_list.size() == 0:
#				$AnimationPlayer.play("idle")
	pass # Replace with function body.



func _on_EnemyDetection_body_entered(body):
	if body.is_in_group("swarm"):
		var is_present = target_list.find(body)
		if is_present != -1:
			pass
		else:
			target_list.push_back(body)
			body.connect("died", self, "on_enemy_died")
	pass # Replace with function body.

func _on_EnemyDetection_body_exited(body):
	if body.is_in_group("swarm"):
		var is_present = target_list.find(body)
		if is_present != -1:
			body.disconnect("died", self, "on_enemy_died")
			target_list.remove(is_present)
	pass # Replace with function body.

func on_enemy_died(enemy):
	var is_present = target_list.find(enemy)
	if is_present != -1:
		target_list.remove(is_present)
#		if target_list.size() == 0:
#			$AnimationPlayer.play("idle")
	pass


func _on_ShotTimer_timeout():
	pass # Replace with function body.
