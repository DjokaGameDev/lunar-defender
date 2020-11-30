extends Area2D

# Export
export var tower_size = 100

# Signals 
signal died(target)
signal change_target(target)

# Variables
var picked = false
var SwarmActorClass = preload("res://actor/Swarm/Miner/Miner.tscn")
var miner_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tower_area_building")
	EventBus.connect("gold_amount_changed", self, "updated_gold_amount")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func _unhandled_input(event : InputEvent):
		#print("input process de merde")
		if event is InputEventMouseMotion:
			pass
		elif event is InputEventMouseButton and event.is_pressed():
			if not picked:
				match event.button_index:
					BUTTON_LEFT:
						if tower_select.selecting_collect_target:
							pass
						else:
							if get_viewport().canvas_transform.affine_inverse().xform(event.position).distance_to(global_position) < 30:
								# left button clicked
								#print("collectible button")
								tower_select.emit_signal("select_tower", self)
								#print("collectible not picked")
					BUTTON_RIGHT:
						pass
						# right button clicked
		else:
				pass

func updated_gold_amount():
	update_buttons()
	pass
	
func update_buttons():
	if (miner_number > 0) or (global.gold_ressource < global.miner_price):
		$GeneralGUI/Control/Button.disabled = true
	else:
		$GeneralGUI/Control/Button.disabled = false
	pass

func tower_selected():
	$GeneralGUI/Control.visible = true
	pass

func tower_unselected():
	$GeneralGUI/Control.visible = false
	pass

func summon_swarm():
	var swarm = SwarmActorClass.instance()
	swarm.global_position = global_position
	swarm.parent_tower = self
	swarm.target = self
	connect("change_target", swarm, "change_target")
	swarm.connect("landed", self, "swarm_landed")
	connect("died", swarm, "parent_died")
	swarm.connect("died", self, "on_swarm_died")
	get_node("../../FlyingObject").add_child(swarm)
	miner_number = miner_number + 1
	update_buttons()
	pass

func _on_Button_pressed():
	if (miner_number < 1) and (global.gold_ressource >= global.miner_price):
		#global.gold_ressource = global.gold_ressource - global.miner_price
		EventBus.emit_signal("add_gold", -global.miner_price)
		summon_swarm()
	pass # Replace with function body.
	
func change_target(_target):
	pass
	
func on_swarm_died(_swarm):
	miner_number = miner_number - 1
	update_buttons()
	pass
