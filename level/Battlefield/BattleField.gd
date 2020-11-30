extends Node2D

#var TowerActorClass = preload("res://actor/Tower/TowerActor.tscn")
var TowerSmallLaserClass = preload("res://actor/Tower/TowerSmallLaser/TowerSmallLaser.tscn")
var TowerBomberClass = preload("res://actor/Tower/TowerBomber/TowerBomber.tscn")
var TowerThunderClass = preload("res://actor/Tower/TowerThunder/TowerThunder.tscn")
var TowerHealerClass = preload("res://actor/Tower/TowerHealing/TowerHealing.tscn")
var Tank1Class = preload("res://actor/Enemy/tank1/Tank1.tscn")
var Tank2Class = preload("res://actor/Enemy/tank2/Tank2.tscn")
var TankHealClass = preload("res://actor/Enemy/tankheal/TankHeal.tscn")
var Tank4Class = preload("res://actor/Enemy/bigtank/BigTank.tscn")
var Ship1Class = preload("res://actor/Enemy/ship1/EnemyShip1bis.tscn")
var Boss1Class = preload("res://actor/Enemy/tank1/Tank1Boss.tscn")
var MeteorClass = preload("res://effects/Meteor/Meteor.tscn")

var wave_tank1_counter = 0
var wave_tank2_counter = 0
var wave_tankheal_counter = 0
var wave_tank4_counter = 0
var wave_tank5_counter = 0
var wave_ship1_counter = 0
var wave_boss1_counter = 0
var meteor_spawn_phase = 30
var meteor_spawned = 0
var meteor_time = 0.2
var meteor_phase_time = 30

var rect_viewport = get_viewport_rect()
var counter_mouse = 0

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/Gold/Label.text = str(global.gold_ressource)
	$GUI/Control/ScrollContainer/GridContainer/TestButton/Label.text = str(global.first_tower_price)
	$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Label.text = str(global.third_tower_price)
	$GUI/Control/ScrollContainer/GridContainer/BomberButton/Label.text = str(global.second_tower_price)
	$GUI/Control/ScrollContainer/GridContainer/HealerButton/Label.text = str(global.forth_tower_price)
	$Particles2D.restart()
	$Particles2D.emitting = true
	
	$GroundObject/PlayerCore.connect("died", self, "defeat")
	EventBus.connect("gold_amount_changed", self, "updated_gold_amount")
	EventBus.connect("unholding_tower", self, "unholding_tower_button")
	
	rect_viewport = get_viewport_rect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	counter_mouse = counter_mouse + 1
	if counter_mouse > 6:
		counter_mouse = 0
#		var mouse_pose = get_viewport().get_mouse_position()
#
#		if mouse_pose.x > 1800:
#			$Camera2D.position = $Camera2D.position + Vector2(200,0)
#			if ($Camera2D.position.x + rect_viewport.size.x / 2.0) > $Camera2D.limit_right:
#				$Camera2D.position.x = $Camera2D.limit_right - rect_viewport.size.x / 2.0
#			pass
#		if mouse_pose.x < 100:
#			$Camera2D.position = $Camera2D.position + Vector2(-200,0)
#			if ($Camera2D.position.x - rect_viewport.size.x / 2.0) < $Camera2D.limit_left:
#				$Camera2D.position.x = $Camera2D.limit_left + rect_viewport.size.x / 2.0
#			pass
#		if mouse_pose.y > 1000 and (mouse_pose.x < 650 or mouse_pose.x > 1250):
#			$Camera2D.position = $Camera2D.position + Vector2(0,200)
#			if ($Camera2D.position.y + rect_viewport.size.y / 2.0) > $Camera2D.limit_bottom:
#				$Camera2D.position.y = $Camera2D.limit_bottom - rect_viewport.size.y / 2.0
#			pass
#		if mouse_pose.y < 100:
#			$Camera2D.position = $Camera2D.position + Vector2(0,-200)
#			if ($Camera2D.position.y - rect_viewport.size.y / 2.0) < $Camera2D.limit_top:
#				$Camera2D.position.y = $Camera2D.limit_top + rect_viewport.size.y / 2.0
#			pass
			
		$GUI/WaveLabel/WaveValue.text = str(global.current_phase)
		
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if _moveCamera:
			$Camera2D.position += (_previousPosition - event.position);
			_previousPosition = event.position;
			
			#print("before" + str($Camera2D.position.x) + " " + str(rect_viewport.size.x / 2.0) + " " + str($Camera2D.limit_right))
			if ($Camera2D.position.x + rect_viewport.size.x / 2.0) > $Camera2D.limit_right:
				$Camera2D.position.x = $Camera2D.limit_right - rect_viewport.size.x / 2.0
			if ($Camera2D.position.x - rect_viewport.size.x / 2.0) < $Camera2D.limit_left:
				$Camera2D.position.x = $Camera2D.limit_left + rect_viewport.size.x / 2.0
			if ($Camera2D.position.y + rect_viewport.size.y / 2.0) > $Camera2D.limit_bottom:
				$Camera2D.position.y = $Camera2D.limit_bottom - rect_viewport.size.y / 2.0
			if ($Camera2D.position.y - rect_viewport.size.y / 2.0) < $Camera2D.limit_top:
				$Camera2D.position.y = $Camera2D.limit_top + rect_viewport.size.y / 2.0
			#print("after" + str($Camera2D.position.x))
			pass
		pass
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				if $Camera2D.zoom.x > 0.5:
					$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1,0.1)
					# call the zoom function
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				if $Camera2D.zoom.x < 2.0:
					$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1,0.1)
					# call the zoom function
			if event.button_index == BUTTON_MIDDLE:
				_previousPosition = event.position;
				_moveCamera = true;
				pass
		else:
			_moveCamera = false;
	if event is InputEventKey:
		if event.is_pressed():
			if event.scancode == KEY_ESCAPE:
				$PauseMenu.set_pause()
				pass
			if event.scancode == KEY_F:
				$GUI/Control.visible = not $GUI/Control.visible
				$GUI/Gold.visible = not $GUI/Gold.visible
				$GUI/WaveLabel.visible = not $GUI/WaveLabel.visible
				$GUI/Sprite.visible = not $GUI/Sprite.visible
				#$GUI/PhaseAnnouncement.visible = not $GUI/PhaseAnnouncement.visible
				pass
	pass

func updated_gold_amount():
	$GUI/Gold/Label.text = str(global.gold_ressource)

	if global.gold_ressource >= global.first_tower_price:
		if $GUI/Control/ScrollContainer/GridContainer/TestButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/TestButton.disabled = false
			$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,1,1,1)
	else:
		if not $GUI/Control/ScrollContainer/GridContainer/TestButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/TestButton.disabled = true
			$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,1,1,0.3)

	if global.gold_ressource >= global.second_tower_price:
		if $GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled = false
			$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,1,1,1)
	else:
		if not $GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled = true
			$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,1,1,0.3)
		
	if global.gold_ressource >= global.third_tower_price:
		if $GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled = false
			$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,1,1,1)
	else:
		if not $GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled = true
			$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,1,1,0.3)
		
	if global.gold_ressource >= global.forth_tower_price:
		if $GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled = false
			$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,1,1,1)
	else:
		if not $GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled:
			$GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled = true
			$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,1,1,0.3)
	pass
	
func unholding_tower_button():
	if not $GUI/Control/ScrollContainer/GridContainer/TestButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,1,1)
	pass
	
func defeat(_target):
	print("You LOST the Moon control !")
	audio_manager.reset_music()
	$LoseGUI.set_pause()
	pass

func win():
	print("You WIN the Moon control !")
	audio_manager.reset_music()
	$WinGUI.set_pause()
	pass
	
func _on_TestButton_pressed():
	if tower_select.holding_tower:
		tower_select.holding_tower.queue_free()
		tower_select.holding_tower = null
	var tower_actor = TowerSmallLaserClass.instance()
	tower_select.holding_tower = tower_actor
	tower_actor.picked = true
	$GroundObject.add_child(tower_actor)
	$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,2,1)
	if not $GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,1,1)
	pass # Replace with function body.


func _on_TankSpawner_timeout():
	
	var counter = 0
	var line_to_spawn = false
	for tank_to_spawn in global.phase[global.current_phase]["tank1_number"]:
		if wave_tank1_counter < tank_to_spawn:
			# Spawn tank on this line
			line_to_spawn = true
			var tank = Tank1Class.instance()
			tank.patrol_path = global.phase[global.current_phase]["tank1_path"][counter]
			tank.position = Vector2(1850,1200)
			$GroundObject.add_child(tank)
			pass
		counter = counter + 1
		pass
	
	wave_tank1_counter = wave_tank1_counter + 1
	
	if $TankSpawner.wait_time != global.phase[global.current_phase]["tank1_timer"]:
		$TankSpawner.wait_time = global.phase[global.current_phase]["tank1_timer"]
		$TankSpawner.stop()
		$TankSpawner.start()
		
	# AUTRE CONDITION D ARRET
	if not line_to_spawn:
		$TankSpawner.stop()
		wave_tank1_counter = 0
	pass # Replace with function body.


func _on_MeteorSpawner_timeout():
	if meteor_spawned == 0:
		$MeteorSpawner.wait_time = meteor_time

	var meteor = MeteorClass.instance()
	meteor.global_position = Vector2(rand_range(-1500,1500), rand_range(-1500,0))
	$GroundObject.add_child(meteor)
	meteor = MeteorClass.instance()
	
	meteor_spawned = meteor_spawned + 1
	if meteor_spawned == meteor_spawn_phase:
		$MeteorSpawner.wait_time = meteor_phase_time
		meteor_spawned = 0
	pass # Replace with function body.


func _on_GoldTimer_timeout():
	#global.gold_ressource = global.gold_ressource + 5
	EventBus.emit_signal("add_gold", 5)
	pass # Replace with function body.


func _on_BomberButton_pressed():
	if tower_select.holding_tower:
		tower_select.holding_tower.queue_free()
		tower_select.holding_tower = null
	var tower_actor = TowerBomberClass.instance()
	tower_select.holding_tower = tower_actor
	tower_actor.picked = true
	$GroundObject.add_child(tower_actor)
	if not $GUI/Control/ScrollContainer/GridContainer/TestButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,1,1)
	$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,2,1)
	if not $GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,1,1)
	pass # Replace with function body.


func _on_ThunderButton_pressed():
	if tower_select.holding_tower:
		tower_select.holding_tower.queue_free()
		tower_select.holding_tower = null
	var tower_actor = TowerThunderClass.instance()
	tower_select.holding_tower = tower_actor
	tower_actor.picked = true
	$GroundObject.add_child(tower_actor)
	if not $GUI/Control/ScrollContainer/GridContainer/TestButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,1,1)
	$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,2,1)
	if not $GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/HealerButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,1,1)
	pass # Replace with function body.


func _on_PhaseTimer_timeout():
	if global.current_phase + 1 in global.phase:
		print("Start next phase !")
		global.current_phase = global.current_phase + 1
		print(global.phase[global.current_phase])
		
		if global.current_phase == 12:
			win()
			return
		
		$GUI/PhaseAnnouncement.text = global.phase[global.current_phase]["message"]
		$GUI/PhaseAnnouncement/AnimationPlayer.play("ShowNewPhase")
		
		if global.phase[global.current_phase]["tank1_wait_time"] != 0:
			$TankSpawner.wait_time = global.phase[global.current_phase]["tank1_wait_time"]
			$TankSpawner.start()
		else:
			if global.phase[global.current_phase]["tank1_timer"] != 0:
				$TankSpawner.wait_time = global.phase[global.current_phase]["tank1_timer"]
				$TankSpawner.start()
			
		if global.phase[global.current_phase]["tank2_wait_time"] != 0:
			$Tank2Spawner.wait_time = global.phase[global.current_phase]["tank2_wait_time"]
			$Tank2Spawner.start()
		else:
			if global.phase[global.current_phase]["tank2_timer"] != 0:
				$Tank2Spawner.wait_time = global.phase[global.current_phase]["tank2_timer"]
				$Tank2Spawner.start()
		
		if global.phase[global.current_phase]["tank3_wait_time"] != 0:
			$TankHealSpawner.wait_time = global.phase[global.current_phase]["tank3_wait_time"]
			$TankHealSpawner.start()
		else:
			if global.phase[global.current_phase]["tank3_timer"] != 0:
				$TankHealSpawner.wait_time = global.phase[global.current_phase]["tank3_timer"]
				$TankHealSpawner.start()
		
		if global.phase[global.current_phase]["tank4_wait_time"] != 0:
			$Tank4Spawner.wait_time = global.phase[global.current_phase]["tank4_wait_time"]
			$Tank4Spawner.start()
		else:
			if global.phase[global.current_phase]["tank4_timer"] != 0:
				$Tank4Spawner.wait_time = global.phase[global.current_phase]["tank4_timer"]
				$Tank4Spawner.start()
		
		if global.phase[global.current_phase]["ship1_wait_time"] != 0:
			$Ship1Spawner.wait_time = global.phase[global.current_phase]["ship1_wait_time"]
			$Ship1Spawner.start()
		else:
			if global.phase[global.current_phase]["ship1_timer"] != 0:
				$Ship1Spawner.wait_time = global.phase[global.current_phase]["ship1_timer"]
				$Ship1Spawner.start()
			
		if global.phase[global.current_phase]["boss1_wait_time"] != 0:
			$Boss1Spawner.wait_time = global.phase[global.current_phase]["boss1_wait_time"]
			$Boss1Spawner.start()
		else:
			if global.phase[global.current_phase]["boss1_timer"] != 0:
				$Boss1Spawner.wait_time = global.phase[global.current_phase]["boss1_timer"]
				$Boss1Spawner.start()
				
		$PhaseTimer.wait_time = global.phase[global.current_phase]["next_phase_wait"]
		$PhaseTimer.stop()
		$PhaseTimer.start()
	else:
		print("Phase not found, stop")
	pass # Replace with function body.




func _on_Ship1Spawner_timeout():
	var counter = 0
	var line_to_spawn = false
	for ship_to_spawn in global.phase[global.current_phase]["ship1_number"]:
		if wave_ship1_counter < ship_to_spawn:
			# Spawn ship on this line
			line_to_spawn = true
			var ship = Ship1Class.instance()
			ship.global_position = global.phase[global.current_phase]["ship1_position"][counter]
			$FlyingObject.add_child(ship)
			pass
		counter = counter + 1
		pass
	
	wave_ship1_counter = wave_ship1_counter + 1
	
	if $Ship1Spawner.wait_time != global.phase[global.current_phase]["ship1_timer"]:
		$Ship1Spawner.wait_time = global.phase[global.current_phase]["ship1_timer"]
		$Ship1Spawner.stop()
		$Ship1Spawner.start()
	
	# AUTRE CONDITION D ARRET
	if not line_to_spawn:
		$Ship1Spawner.stop()
		wave_ship1_counter = 0
	pass # Replace with function body.



func _on_Tank2Spawner_timeout():
	var counter = 0
	var line_to_spawn = false
	for tank_to_spawn in global.phase[global.current_phase]["tank2_number"]:
		if wave_tank2_counter < tank_to_spawn:
			# Spawn tank on this line
			line_to_spawn = true
			var tank = Tank2Class.instance()
			tank.patrol_path = global.phase[global.current_phase]["tank2_path"][counter]
			tank.position = Vector2(1850,1200)
			$GroundObject.add_child(tank)
			pass
		counter = counter + 1
		pass
	
	wave_tank2_counter = wave_tank2_counter + 1
	
	if $Tank2Spawner.wait_time != global.phase[global.current_phase]["tank2_timer"]:
		$Tank2Spawner.wait_time = global.phase[global.current_phase]["tank2_timer"]
		$Tank2Spawner.stop()
		$Tank2Spawner.start()
		
	# AUTRE CONDITION D ARRET
	if not line_to_spawn:
		$Tank2Spawner.stop()
		wave_tank2_counter = 0
	pass # Replace with function body.


func _on_TankHealSpawner_timeout():
	var counter = 0
	var line_to_spawn = false
	for tank_to_spawn in global.phase[global.current_phase]["tank3_number"]:
		if wave_tankheal_counter < tank_to_spawn:
			# Spawn tank on this line
			line_to_spawn = true
			var tank = TankHealClass.instance()
			tank.patrol_path = global.phase[global.current_phase]["tank3_path"][counter]
			tank.position = Vector2(1850,1200)
			$GroundObject.add_child(tank)
			pass
		counter = counter + 1
		pass
	
	wave_tankheal_counter = wave_tankheal_counter + 1
	
	if $TankHealSpawner.wait_time != global.phase[global.current_phase]["tank3_timer"]:
		$TankHealSpawner.wait_time = global.phase[global.current_phase]["tank3_timer"]
		$TankHealSpawner.stop()
		$TankHealSpawner.start()
		
	# AUTRE CONDITION D ARRET
	if not line_to_spawn:
		$TankHealSpawner.stop()
		wave_tankheal_counter = 0
	pass # Replace with function body.


func _on_HealerButton_pressed():
	if tower_select.holding_tower:
		tower_select.holding_tower.queue_free()
		tower_select.holding_tower = null
	var tower_actor = TowerHealerClass.instance()
	tower_select.holding_tower = tower_actor
	tower_actor.picked = true
	$GroundObject.add_child(tower_actor)
	if not $GUI/Control/ScrollContainer/GridContainer/TestButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/TestButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/ThunderButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/ThunderButton/Sprite.modulate = Color(1,1,1)
	if not $GUI/Control/ScrollContainer/GridContainer/BomberButton.disabled:
		$GUI/Control/ScrollContainer/GridContainer/BomberButton/Sprite.modulate = Color(1,1,1)
	$GUI/Control/ScrollContainer/GridContainer/HealerButton/Sprite.modulate = Color(1,2,1)
	pass # Replace with function body.


func _on_Tank4Spawner_timeout():
	var counter = 0
	var line_to_spawn = false
	for tank_to_spawn in global.phase[global.current_phase]["tank4_number"]:
		if wave_tank4_counter < tank_to_spawn:
			# Spawn tank on this line
			line_to_spawn = true
			var tank = Tank4Class.instance()
			tank.patrol_path = global.phase[global.current_phase]["tank4_path"][counter]
			tank.position = Vector2(1850,1200)
			$GroundObject.add_child(tank)
			pass
		counter = counter + 1
		pass
	
	wave_tank4_counter = wave_tank4_counter + 1
	
	if $Tank4Spawner.wait_time != global.phase[global.current_phase]["tank4_timer"]:
		$Tank4Spawner.wait_time = global.phase[global.current_phase]["tank4_timer"]
		$Tank4Spawner.stop()
		$Tank4Spawner.start()
		
	# AUTRE CONDITION D ARRET
	if not line_to_spawn:
		$Tank4Spawner.stop()
		wave_tank4_counter = 0
	pass # Replace with function body.


func _on_Boss1Spawner_timeout():
	var counter = 0
	var line_to_spawn = false
	for tank_to_spawn in global.phase[global.current_phase]["boss1_number"]:
		if wave_boss1_counter < tank_to_spawn:
			# Spawn tank on this line
			line_to_spawn = true
			var tank = Boss1Class.instance()
			tank.patrol_path = global.phase[global.current_phase]["boss1_path"][counter]
			tank.position = Vector2(1850,1200)
			$GroundObject.add_child(tank)
			pass
		counter = counter + 1
		pass
	
	wave_boss1_counter = wave_boss1_counter + 1
	
	if $Boss1Spawner.wait_time != global.phase[global.current_phase]["boss1_timer"]:
		$Boss1Spawner.wait_time = global.phase[global.current_phase]["boss1_timer"]
		$Boss1Spawner.stop()
		$Boss1Spawner.start()
		
	# AUTRE CONDITION D ARRET
	if not line_to_spawn:
		$Boss1Spawner.stop()
		wave_boss1_counter = 0
	pass # Replace with function body.  


func _on_TTC1_OkButton_pressed():
	$Tooltips/ToolTipCollector.visible = false
	pass # Replace with function body.


func _on_TTC2_OkButton_pressed():
	$Tooltips/ToolTipCollector2.visible = false
	pass # Replace with function body.


func _on_TTM_OkButton_pressed():
	$Tooltips/ToolTipMiner.visible = false
	pass # Replace with function body.


func _on_TTUI_OkButton_pressed():
	$Tooltips/UIToolTip/ToolTipUI.visible = false
	pass # Replace with function body.
