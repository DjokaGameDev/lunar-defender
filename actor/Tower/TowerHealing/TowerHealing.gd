extends "res://actor/Tower/TowerActor.gd"

# Export
export var healing_target = 2

# Signals 


# Variables
var sorted_enemies = []


# Called when the node enters the scene tree for the first time.
func _ready():
	SwarmActorClass = preload("res://actor/Swarm/HealingDrone/HealingDrone.tscn")
	health = starting_health
	swarm_inside = max_swarm_number
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	$GUI/SwarmBar.max_value = max_swarm_number
	$GUI/SwarmBar.value = swarm_outside + swarm_inside
	add_to_group("tower")
	$AnimationPlayer.play("idle")
	swarm_price = global.forth_tower_swarm_price
	max_swarm_price = global.forth_tower_max_swarm_price
	max_upgrade = global.forth_tower_max_swarm_upgrade
	
	$GeneralGUI/Control/AddSwarmButton/Label.text = str(swarm_price)
	$GeneralGUI/Control/IncreaseMaxSwarmButton/Label.text = str(max_swarm_price)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func specific_process(_delta):
	sorted_enemies.clear()
	sorted_enemies.empty()
	var healing_counter = 0
	for enemy in enemy_collision_list:
		if enemy.is_in_group("swarm"):
			if enemy.health < (enemy.starting_health - 5):
				if healing_counter < healing_target:
					sorted_enemies.push_back(enemy)
					healing_counter = healing_counter + 1
				pass
		else:
#			if enemy.get_parent().health < (enemy.get_parent().starting_health - 5):
#				if healing_counter < healing_target:
#					sorted_enemies.push_back(enemy)
#					healing_counter = healing_counter + 1
#				pass
			if enemy.health < (enemy.starting_health - 5):
				if healing_counter < healing_target:
					sorted_enemies.push_back(enemy)
					healing_counter = healing_counter + 1
				pass
		pass
		
	if tower_state == TOWER_CLOSED and swarm_inside > 0:
		if sorted_enemies.size() > 0:
			print("sorted size" + str(sorted_enemies.size()))
			open_tower()
	if tower_state == TOWER_OPENED:
		if swarm_outside == 0:
			close_tower()
	pass

func _on_TowerActor_area_entered(area):
	if area.is_in_group("tower_building"):
		var real_tower = area.get_parent()
		var is_present = enemy_collision_list.find(real_tower)
		if is_present != -1:
			pass
		else:
			enemy_collision_list.push_back(real_tower)
			real_tower.connect("died", self, "on_enemy_died")
	pass # Replace with function body.


func _on_TowerActor_area_exited(area):
	if area.is_in_group("tower_building"):
		var real_tower = area.get_parent()
		var is_present = enemy_collision_list.find(real_tower)
		if is_present != -1:
			enemy_collision_list.remove(is_present)
			real_tower.disconnect("died", self, "on_enemy_died")
	pass # Replace with function body.
	
func _on_TowerHealing_body_entered(body):
	#print("body entering")
	if body.is_in_group("swarm"):
		var is_present = enemy_collision_list.find(body)
		#print(is_present)
		if is_present != -1:
			pass
		else:
			enemy_collision_list.push_back(body)
			body.connect("died", self, "on_enemy_died")
#			if enemy_collision_list.size() == 1:
#				if not $AnimationPlayer.is_playing() and swarm_outside == 0:
#					$AnimationPlayer.play("open")
#					#yield($AnimationPlayer,"animation_finished")
#					#summon_swarm()
#					#emit_signal("change_target", body)
#					#body.modify_health(-100)
#				else:
#					call_deferred("summon_swarm")#summon_swarm()
#					pass
#			else:
#				call_deferred("summon_swarm")#summon_swarm()
			#emit_signal("change_target", enemy_collision_list[0])
					
	pass # Replace with function body.


func _on_TowerHealing_body_exited(body):
	#print("body exiting")
	if body.is_in_group("swarm"):
		var is_present = enemy_collision_list.find(body)
		if is_present != -1:
			enemy_collision_list.remove(is_present)
			body.disconnect("died", self, "on_enemy_died")
#			if enemy_collision_list.size() == 0:
#				emit_signal("change_target", null)
#				#$AnimationPlayer.play("idle")
#			else:
#				emit_signal("change_target", enemy_collision_list[0])
	pass # Replace with function body.

func on_enemy_died(enemy):
	var is_present = enemy_collision_list.find(enemy)
	if is_present != -1:
		enemy_collision_list.remove(is_present)
#		if enemy_collision_list.size() == 0:
#			emit_signal("change_target", null)
#			#$AnimationPlayer.play("idle")
#		else:
#			emit_signal("change_target", enemy_collision_list[0])
#			pass
	pass


