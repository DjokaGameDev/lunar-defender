extends Area2D

# Export
export var starting_health = 1000
export var tower_size = 200

# Signals 
signal died(target)

# Variables
var SwarmActorClass = preload("res://actor/Swarm/Collector/Collector.tscn")
var health = 0.0
var actor_enabled = true
var collector_number = 1
var collector_out = 0

var selecting_collect = false
var max_points_collect = 1
var current_point_collect = 0
var collect_list = []
var start_point_collect = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	health = starting_health
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	
	$GeneralGUI/Control/CollectButton/AvailableLabel.text = str(collector_number - collector_out)
	$GeneralGUI/Control/CollectButton/MaxLabel.text = "/" + str(collector_number)
	
	add_to_group("tower")
	EventBus.connect("gold_amount_changed", self, "updated_gold_amount")
	#$AnimationPlayer.play("idle")
	pass # Replace with function body.

func _process(_delta):
	if (collector_number <= collector_out):
		$GeneralGUI/Control/CollectButton.disabled = true
	else:
		$GeneralGUI/Control/CollectButton.disabled = false
		
	if not selecting_collect and tower_select.selecting_collect_target:
		tower_select.selecting_collect_target = null
	pass

func _input(event : InputEvent):
		#print("input process de merde")
		if event is InputEventMouseMotion:
			if tower_select.selecting_collect_target:
				$CollectorLine.points[1] = to_local(get_viewport().canvas_transform.affine_inverse().xform(event.position))
			pass
		elif event is InputEventMouseButton and event.is_pressed():
			match event.button_index:
				BUTTON_LEFT:
					if tower_select.selecting_collect_target:
						get_tree().set_input_as_handled();
						#print("set handled")
						if current_point_collect < max_points_collect:
							# Intermediate point
							start_point_collect = to_local(get_viewport().canvas_transform.affine_inverse().xform(event.position))
							collect_list.push_back(get_viewport().canvas_transform.affine_inverse().xform(event.position))
							$CollectorLine.points[0] = start_point_collect
							current_point_collect = current_point_collect + 1
						else:
							# Final point
							#start_point_collect = get_viewport().canvas_transform.affine_inverse().xform(event.position)
							collect_list.push_back(get_viewport().canvas_transform.affine_inverse().xform(event.position))
							go_collect(collect_list)
							collect_list.clear()
							start_point_collect = Vector2(0,0)
							#tower_select.selecting_collect_target = null
							$CollectorLine.visible = false
							Input.set_default_cursor_shape(Input.CURSOR_ARROW)
							#print("set handled")
							selecting_collect = false
							pass
						pass
					else:
						if get_viewport().canvas_transform.affine_inverse().xform(event.position).distance_to(global_position) < 30:
							# left button clicked
							$WaitingOrdersAudio.play()
							#print("button")
							tower_select.emit_signal("select_tower", self)
							#print("not picked")
							$CollectorLine.visible = false
							Input.set_default_cursor_shape(Input.CURSOR_ARROW)
				BUTTON_RIGHT:
					$CollectorLine.visible = false
					Input.set_default_cursor_shape(Input.CURSOR_ARROW)
					pass
					# right button clicked
		else:
				pass

func updated_gold_amount():
	if (global.gold_ressource < global.collector_price):
		$GeneralGUI/Control/BuyCollectorButton.disabled = true
	else:
		$GeneralGUI/Control/BuyCollectorButton.disabled = false
	pass

func tower_selected():
	$GeneralGUI/Control.visible = true
	pass

func tower_unselected():
	$GeneralGUI/Control.visible = false
	pass

func modify_health(value):
	if health > 0:
		if value < 0: # Damage
			if $UnderAttackTimer.is_stopped():
				$UnderAttackAudio.play()
			$UnderAttackTimer.stop()
			$UnderAttackTimer.start()
			$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), Color(0, 0, 0, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_property($Sprite, "modulate", Color(0, 0, 0, 1), Color(1, 1, 1, 1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.05)
			$Tween.start()
		else: # Heal
			value = value / 2
		health = health + value
		$GUI/LifeBar.value = health
		if health <= 0:
			emit_signal("died", self)
			destroy_instance()
	pass
	
func destroy_instance():
	EventBus.emit_signal("shake_camera", 0.5)
	queue_free()
	pass

func go_collect(position):
	$GoCollectAudio.stream = load("res://assets/sfx/voices/H_ECONF"+str(1+(randi() % 3))+".wav")
	$GoCollectAudio.play()
	var swarm = SwarmActorClass.instance()
	swarm.global_position = global_position
	swarm.parent_tower = self
	print(position)
	swarm.path_target = [] + position
	swarm.target = position[0]
	#connect("change_target", swarm, "change_target")
	swarm.connect("landed", self, "swarm_landed")
	connect("died", swarm, "parent_died")
	swarm.connect("died", self, "on_swarm_died")
	get_node("../../FlyingObject").add_child(swarm)
	collector_out = collector_out + 1
	$GeneralGUI/Control/CollectButton/AvailableLabel.text = str(collector_number - collector_out)
	pass

func swarm_landed():
	collector_out = collector_out - 1
	$GeneralGUI/Control/CollectButton/AvailableLabel.text = str(collector_number - collector_out)
	$GeneralGUI/Control/CollectButton/MaxLabel.text = "/" + str(collector_number)
	pass
	
func _on_RegenTimer_timeout():
	health = health + 0.01 * starting_health
	if health > starting_health:
		health = starting_health
	$GUI/LifeBar.value = health
	pass # Replace with function body.


func _on_CollectButton_pressed():
	if collector_number > collector_out:
		collect_list.clear()
		tower_select.selecting_collect_target = true
		selecting_collect = true
		current_point_collect = 0
		start_point_collect = Vector2(0,0)
		$CollectorLine.points[0] = start_point_collect
		$CollectorLine.visible = true
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	if collector_number <= collector_out:
		$GeneralGUI/Control/CollectButton.disabled = true
	pass # Replace with function body.


func _on_BuyCollectorButton_pressed():
	if (global.gold_ressource >= global.collector_price):
		#global.gold_ressource = global.gold_ressource - global.collector_price
		EventBus.emit_signal("add_gold", -global.collector_price)
		collector_number = collector_number + 1
		$GeneralGUI/Control/CollectButton/AvailableLabel.text = str(collector_number - collector_out)
		$GeneralGUI/Control/CollectButton/MaxLabel.text = "/" + str(collector_number)
	pass # Replace with function body.


func _on_UnderAttackTimer_timeout():
	pass # Replace with function body.
