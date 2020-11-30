extends Area2D

# Export
export var starting_health = 100
export var max_swarm_number = 2
export var tower_size = 100
export(global.tower_type) var type = global.tower_type.TOWER_LASER

# Signals 
signal died(target)
signal change_target(target)

# Variables
var health = 0.0
var swarm_outside = 0
var swarm_inside = 0
var picked = false
var actor_enabled = false 
var tower_collision_list = []
var enemy_collision_list =  []
var SwarmActorClass = preload("res://actor/Swarm/SwarmActor.tscn")
#var SwarmActorClass = preload("res://actor/Swarm/BomberSwarm/BomberSwarm.tscn")
var explosion = preload("res://effects/BigExplosion/BigExplosion.tscn")
var harvestable = preload("res://level/Battlefield/HarvestableRessource.tscn")
var max_swarm_upgrade = 0
var swarm_price = 0
var max_swarm_price = 0
var max_upgrade = 0

enum {
	TOWER_CLOSED,
	TOWER_OPENING,
	TOWER_OPENED,
	TOWER_CLOSING
}
var tower_state = TOWER_CLOSED


# Called when the node enters the scene tree for the first time.
func _ready():
	health = starting_health
	swarm_inside = max_swarm_number
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	$GUI/SwarmBar.max_value = max_swarm_number
	$GUI/SwarmBar.value = swarm_outside + swarm_inside
	add_to_group("tower")
	$AnimationPlayer.play("idle")
	EventBus.connect("gold_amount_changed", self, "updated_gold_amount")
	swarm_price = global.first_tower_swarm_price
	max_swarm_price = global.first_tower_max_swarm_price
	max_upgrade = global.first_tower_max_swarm_upgrade
	
	if max_swarm_number == 1:
		$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/HUD Hangar 1+1.png")
	elif max_swarm_number == 2:
		$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/HUD Hangar 2+1.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GUI/SwarmBar.max_value = max_swarm_number
	$GUI/SwarmBar.value = swarm_outside + swarm_inside

	#print("test"+str(swarm_outside)+"/"+str(swarm_inside))

	specific_process(delta)

	pass

func specific_process(_delta):
	if tower_state == TOWER_CLOSED and swarm_inside > 0:
		if enemy_collision_list.size() > 0:
			open_tower()
	if tower_state == TOWER_OPENED:
		if swarm_outside <= 0:
			close_tower()
	pass
	
func _input(event : InputEvent):
		#print("input process de merde")
#		if event is InputEventMouseMotion:
#			pass
		if event is InputEventMouseButton and event.is_pressed():
			if not picked:
				match event.button_index:
					BUTTON_LEFT:
						if tower_select.selecting_collect_target:
							pass
						else:
							if get_viewport().canvas_transform.affine_inverse().xform(event.position).distance_to(global_position) < 30:
								# left button clicked
								#print("button")
								tower_select.emit_signal("select_tower", self)
								#print("not picked")
#					BUTTON_RIGHT:
#						pass
						# right button clicked
#		else:
#				pass

func updated_gold_amount():
	update_buttons()
	pass

func update_buttons():
	if ((swarm_outside + swarm_inside) < max_swarm_number) and (swarm_price < global.gold_ressource):
		$GeneralGUI/Control/AddSwarmButton.disabled = false
	else:
		$GeneralGUI/Control/AddSwarmButton.disabled = true

	if (max_upgrade > max_swarm_upgrade) and (max_swarm_price < global.gold_ressource):
		$GeneralGUI/Control/IncreaseMaxSwarmButton.disabled = false
	else:
		$GeneralGUI/Control/IncreaseMaxSwarmButton.disabled = true
	pass

func drop_on_ground():
	if tower_collision_list.size() == 0:
		picked = false
		$AoESprite.visible = false
		actor_enabled = true
		#$BuildingCollision.connect("area_entered", self, "_on_BuildingCollision_area_entered")
		#$BuildingCollision.connect("area_exited", self, "_on_BuildingCollision_area_exited")
		connect("body_entered", self, "_on_TowerActor_body_entered")
		connect("body_exited", self, "_on_TowerActor_body_exited")
		$TowerAreaOfEffect.disabled = false
		$BuildingCollision.collision_layer = 1
		$DropOnGroundParticles.emitting = true
		$DropOnGroundParticles.restart()
		$BuildAudioStreamPlayer2D.play()
		#$AnimationPlayer.play("open")
		return true
	else:
		return false
	pass

func open_tower():
	tower_state = TOWER_OPENING
	$AnimationPlayer.play("open")
	pass
	
func close_tower():
	tower_state = TOWER_CLOSING
	$NextSwarmTimer.stop()
	$AnimationPlayer.play("close")
	pass

func tower_opened():
	tower_state = TOWER_OPENED
	$NextSwarmTimer.start()
	summon_swarm()
	pass
	
func tower_closed():
	tower_state = TOWER_CLOSED
	$AnimationPlayer.play("idle")
	pass

func modify_health(value):
	health = health + value
	if health > starting_health:
		health = starting_health
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
	EventBus.emit_signal("shake_camera", 0.5)
	
	call_deferred("drop_gold")
	
	queue_free()
	pass

func drop_gold():
	var new_gold = harvestable.instance()
	new_gold.global_position = global_position
	new_gold.value = 10
	get_tree().get_root().get_node_or_null("BattleField/GroundObject").add_child(new_gold)

func summon_swarm():
	#$NextSwarmTimer.stop()
	if tower_state == TOWER_OPENED and swarm_inside > 0 and enemy_collision_list.size() > 0:
		var swarm = SwarmActorClass.instance()
		swarm.global_position = global_position
		swarm.parent_tower = self
		swarm.target = enemy_collision_list[0]
		connect("change_target", swarm, "change_target")
		swarm.connect("landed", self, "swarm_landed")
		connect("died", swarm, "parent_died")
		swarm.connect("died", self, "on_swarm_died")
		get_node("../../FlyingObject").add_child(swarm)
		swarm_outside = swarm_outside + 1
		swarm_inside = swarm_inside - 1
		if enemy_collision_list.size() == 0:
			emit_signal("change_target", null)
			#$AnimationPlayer.play("idle")
			if swarm_outside <= 0:
				close_tower()
		else:
			emit_signal("change_target", enemy_collision_list[0])
		if swarm_inside > 0:
			$NextSwarmTimer.start()
	else:
		if swarm_outside <= 0:
			close_tower()
		pass
	update_buttons()
	pass

func swarm_landed():
	swarm_outside = swarm_outside - 1
	swarm_inside = swarm_inside + 1
	#print("landed"+str(swarm_outside)+"/"+str(swarm_inside))
	if swarm_outside <= 0:
		close_tower()
	update_buttons()
	pass

func tower_selected():
	$GeneralGUI/Control.visible = true
	pass

func tower_unselected():
	$GeneralGUI/Control.visible = false
	pass
	
func _on_TowerActor_area_entered(_area):
	pass # Replace with function body.

func _on_TowerActor_area_exited(_area):
	pass # Replace with function body.

func _on_BuildingCollision_area_entered(area):
	if (area.is_in_group("tower_building") or area.is_in_group("tower_area_building")) and area != self:
		var is_present = tower_collision_list.find(area)
		#print(is_present)
		if is_present != -1:
			pass
		else:
			tower_collision_list.push_back(area)
			if tower_collision_list.size() == 1:
				$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(1, 0, 0, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()
			pass
	else:
		# Projectile
		pass
	pass # Replace with function body.


func _on_BuildingCollision_area_exited(area):
	if (area.is_in_group("tower_building") or area.is_in_group("tower_area_building")) and area != self:
		var is_present = tower_collision_list.find(area)
		if is_present != -1:
			tower_collision_list.remove(is_present)
			if tower_collision_list.size() == 0:
				$Tween.interpolate_property($Sprite, "modulate", Color(1, 0, 0, 1), Color(1, 1, 1, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()
			pass
		else:
			pass
	else:
		# Projectile
		pass
	pass # Replace with function body.



func _on_TowerActor_body_entered(body):
	#print("body entering")
	if body.is_in_group("enemy"):
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
			emit_signal("change_target", enemy_collision_list[0])
					
	pass # Replace with function body.


func _on_TowerActor_body_exited(body):
	#print("body exiting")
	if body.is_in_group("enemy"):
		var is_present = enemy_collision_list.find(body)
		if is_present != -1:
			enemy_collision_list.remove(is_present)
			body.disconnect("died", self, "on_enemy_died")
			if enemy_collision_list.size() == 0:
				emit_signal("change_target", null)
				#$AnimationPlayer.play("idle")
			else:
				emit_signal("change_target", enemy_collision_list[0])
	pass # Replace with function body.

func on_enemy_died(enemy):
	var is_present = enemy_collision_list.find(enemy)
	if is_present != -1:
		enemy_collision_list.remove(is_present)
		if enemy_collision_list.size() == 0:
			emit_signal("change_target", null)
			#$AnimationPlayer.play("idle")
		else:
			emit_signal("change_target", enemy_collision_list[0])
			pass
	pass

func on_swarm_died(_swarm):
	swarm_outside = swarm_outside - 1
	if swarm_outside < 0:
		swarm_outside = 0
	update_buttons()
	pass

func _on_NextSwarmTimer_timeout():
	summon_swarm()
	pass # Replace with function body.


func _on_AddSwarmButton_pressed():
	if ((swarm_outside + swarm_inside) < max_swarm_number) and (swarm_price < global.gold_ressource):
		swarm_inside = swarm_inside + 1
		#global.gold_ressource = global.gold_ressource - global.first_tower_swarm_price
		EventBus.emit_signal("add_gold", -swarm_price)
	pass # Replace with function body.


func _on_IncreaseMaxSwarmButton_pressed():
	if max_upgrade > max_swarm_upgrade:
		max_swarm_upgrade = max_swarm_upgrade + 1
		max_swarm_number = max_swarm_number + 1
		#global.gold_ressource = global.gold_ressource - global.first_tower_max_swarm_price
		EventBus.emit_signal("add_gold", -max_swarm_price)
		if max_swarm_number == 1:
			$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/HUD Hangar 1+1.png")
		elif max_swarm_number == 2:
			$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/HUD Hangar 2+1.png")
		elif max_swarm_number == 3:
			$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/HUD Hangar 3+1.png")
		
#		if max_swarm_upgrade == 1:
#			$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/Star_02.png")
#		if max_swarm_upgrade == 2:
#			$GeneralGUI/Control/IncreaseMaxSwarmButton.icon = load("res://assets/img/GUI/Star_03.png")
	pass # Replace with function body.
