extends "res://actor/Tower/TowerActor.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	SwarmActorClass = preload("res://actor/Swarm/BomberSwarm/BomberSwarm.tscn")
	health = starting_health
	swarm_inside = max_swarm_number
	$GUI/LifeBar.max_value = starting_health
	$GUI/LifeBar.value = health
	$GUI/SwarmBar.max_value = max_swarm_number
	$GUI/SwarmBar.value = swarm_outside + swarm_inside
	add_to_group("tower")
	$AnimationPlayer.play("idle")
	swarm_price = global.second_tower_swarm_price
	max_swarm_price = global.second_tower_max_swarm_price
	max_upgrade = global.second_tower_max_swarm_upgrade
	
	$GeneralGUI/Control/AddSwarmButton/Label.text = str(swarm_price)
	$GeneralGUI/Control/IncreaseMaxSwarmButton/Label.text = str(max_swarm_price)
	pass # Replace with function body.
