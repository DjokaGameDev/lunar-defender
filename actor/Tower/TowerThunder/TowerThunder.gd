extends "res://actor/Tower/TowerActor.gd"

var bouncing_number = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	SwarmActorClass = preload("res://actor/Swarm/ThunderSwarm/ThunderSwarm.tscn")
	health = starting_health
	swarm_inside = max_swarm_number
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	$GUI/SwarmBar.max_value = max_swarm_number
	$GUI/SwarmBar.value = swarm_outside + swarm_inside
	add_to_group("tower")
	$AnimationPlayer.play("idle")
	swarm_price = global.third_tower_swarm_price
	max_swarm_price = global.third_tower_max_swarm_price
	max_upgrade = global.third_tower_max_swarm_upgrade
	
	$GeneralGUI/Control/AddSwarmButton/Label.text = str(swarm_price)
	$GeneralGUI/Control/IncreaseMaxSwarmButton/Label.text = str(max_swarm_price)
	pass # Replace with function body.

func summon_swarm():
	#$NextSwarmTimer.stop()
	if tower_state == TOWER_OPENED and swarm_inside > 0 and enemy_collision_list.size() > 0:
		var swarm = SwarmActorClass.instance()
		swarm.global_position = global_position
		swarm.parent_tower = self
		swarm.target = enemy_collision_list[0]
		swarm.id = swarm_outside % 2
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
