extends Node

enum {
	RESSOURCE_GOLD,
	RESSOURCE_LIFE
}

enum enemy_type {
	ENEMY_TANK1,
	ENEMY_TANK2,
	ENEMY_TANK3,
	ENEMY_TANK4,
	ENEMY_SHIP1,
	ENEMY_BOSS1
}

enum tower_type {
	TOWER_LASER,
	TOWER_BOMB,
	TOWER_THUNDER,
	TOWER_HEAL
}

var phase = {
	1: {
		"tank1_number" : [20],
		"tank1_timer" : 0,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [10],
		"tank2_timer" : 1.5,
		"tank2_wait_time" : 0,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [5],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [2],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [5],
		"ship1_timer" : 0,
		"ship1_wait_time" : 0,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from EAST",
		"next_phase_wait": 50
	},
	2: {
		"tank1_number" : [10],
		"tank1_timer" : 2,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [10, 5],
		"tank2_timer" : 1.5,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [5],
		"ship1_timer" : 0,
		"ship1_wait_time" : 0,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from EAST / N-E",
		"next_phase_wait": 85
	},
	3: {
		"tank1_number" : [10, 5],
		"tank1_timer" : 0,
		"tank1_wait_time" : 2,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [10, 7],
		"tank2_timer" : 1.5,
		"tank2_wait_time" : 10,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [10, 5],
		"ship1_timer" : 0,
		"ship1_wait_time" : 0,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400)],
		"boss1_number" : [1],
		"boss1_timer" : 1,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Small Boss coming from EAST",
		"next_phase_wait": 90
	},
	4: {
		"tank1_number" : [10, 7, 5],
		"tank1_timer" : 2,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [10, 7, 5, 5],
		"tank2_timer" : 1.5,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [5, 5],
		"ship1_timer" : 0,
		"ship1_wait_time" : 0,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from Everywhere",
		"next_phase_wait": 90
	},
	5: {
		"tank1_number" : [10, 10, 7, 7],
		"tank1_timer" : 1.5,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [10, 10, 10, 7],
		"tank2_timer" : 2,
		"tank2_wait_time" : 20,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [1, 1, 1, 1],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [3, 3],
		"ship1_timer" : 2,
		"ship1_wait_time" : 15,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from Everywhere",
		"next_phase_wait": 90
	},
	6: {
		"tank1_number" : [10, 10, 10, 10],
		"tank1_timer" : 1.5,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [10, 10, 10, 10],
		"tank2_timer" : 2,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [2, 2],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [3, 3],
		"ship1_timer" : 2,
		"ship1_wait_time" : 15,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from Everywhere",
		"next_phase_wait": 90
	},
	7: {
		"tank1_number" : [5, 5, 5, 5],
		"tank1_timer" : 1.5,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank2_number" : [5, 5, 5, 5],
		"tank2_timer" : 1.5,
		"tank2_wait_time" : 10,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank3_number" : [1, 1, 1, 1],
		"tank3_timer" : 4,
		"tank3_wait_time" : 4,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank4_number" : [5, 5],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"ship1_number" : [3, 3],
		"ship1_timer" : 2,
		"ship1_wait_time" : 15,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from Everywhere",
		"next_phase_wait": 90
	},
	8: {
		"tank1_number" : [5, 5, 5, 5],
		"tank1_timer" : 1,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank2_number" : [5, 5, 5, 5],
		"tank2_timer" : 1,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank3_number" : [2, 2, 2, 2],
		"tank3_timer" : 3,
		"tank3_wait_time" : 2,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank4_number" : [],
		"tank4_timer" : 0,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"ship1_number" : [5, 5, 4, 3, 3],
		"ship1_timer" : 1,
		"ship1_wait_time" : 20,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from EVERYWHERE",
		"next_phase_wait": 90
	},
	9: {
		"tank1_number" : [5, 5, 5, 5],
		"tank1_timer" : 1.0,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank2_number" : [5, 5, 5, 5],
		"tank2_timer" : 0,
		"tank2_wait_time" : 0,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank3_number" : [],
		"tank3_timer" : 0,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank4_number" : [1, 1, 1, 1],
		"tank4_timer" : 1,
		"tank4_wait_time" : 3,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"ship1_number" : [5, 5, 4, 3, 3],
		"ship1_timer" : 1,
		"ship1_wait_time" : 15,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "TODO Enemies are coming from Everywhere",
		"next_phase_wait": 90
	},
	10: {
		"tank1_number" : [5, 5, 5, 5],
		"tank1_timer" : 1,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank2_number" : [5, 5, 5, 5, 5],
		"tank2_timer" : 1,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank3_number" : [1, 1, 1, 1],
		"tank3_timer" : 3,
		"tank3_wait_time" : 3,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank4_number" : [1, 1],
		"tank4_timer" : 2.5,
		"tank4_wait_time" : 2,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_4", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"ship1_number" : [5, 5, 5, 5, 5],
		"ship1_timer" : 1,
		"ship1_wait_time" : 15,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from Everywhere",
		"next_phase_wait": 90
	},
	11: {
		"tank1_number" : [5, 5, 5, 5, 5],
		"tank1_timer" : 1,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank2_number" : [10, 10, 10, 10, 10],
		"tank2_timer" : 1,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank3_number" : [2, 2, 2, 2, 2],
		"tank3_timer" : 3,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"tank4_number" : [1, 1, 1, 1, 1],
		"tank4_timer" : 2.5,
		"tank4_wait_time" : 2,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5", "../../Path2D_3"],
		"ship1_number" : [5, 5, 5, 5, 5],
		"ship1_timer" : 1,
		"ship1_wait_time" : 20,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1, 1],
		"boss1_timer" : 2,
		"boss1_wait_time" : 1,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_4", "../../Path2D_2", "../../Path2D_5"],
		"message" : "Enemies are coming from Everywhere",
		"next_phase_wait": 100
	},
	12: {
		"tank1_number" : [15, 15, 15, 15, 15],
		"tank1_timer" : 1,
		"tank1_wait_time" : 0,
		"tank1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_3", "../../Path2D_4", "../../Path2D_5"],
		"tank2_number" : [15, 15, 15, 15, 15],
		"tank2_timer" : 1,
		"tank2_wait_time" : 15,
		"tank2_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_3", "../../Path2D_4", "../../Path2D_5"],
		"tank3_number" : [5, 5, 5, 5, 5],
		"tank3_timer" : 3,
		"tank3_wait_time" : 0,
		"tank3_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_3", "../../Path2D_4", "../../Path2D_5"],
		"tank4_number" : [5, 5, 5, 5, 5],
		"tank4_timer" : 2.5,
		"tank4_wait_time" : 0,
		"tank4_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_3", "../../Path2D_4", "../../Path2D_5"],
		"ship1_number" : [15, 15],
		"ship1_timer" : 1,
		"ship1_wait_time" : 20,
		"ship1_position" : [Vector2(2168,180), Vector2(1200,-1400), Vector2(-1200,-1400), Vector2(-2400,300), Vector2(-100,1500)],
		"boss1_number" : [1],
		"boss1_timer" : 0,
		"boss1_wait_time" : 0,
		"boss1_path" : ["../../Path2D_1", "../../Path2D_2", "../../Path2D_4", "../../Path2D_5"],
		"message" : "Enemies are coming from EAST",
		"next_phase_wait": 90
	},
}

var current_phase = 0

var gold_ressource = 1000

# Small shooter
var first_tower_price = 75
var first_tower_swarm_price = 20
var first_tower_max_swarm_price = 40
var first_tower_max_swarm_upgrade = 2

# Bomber
var second_tower_price = 200
var second_tower_swarm_price = 100
var second_tower_max_swarm_price = 100
var second_tower_max_swarm_upgrade = 1

# Thunder
var third_tower_price = 150
var third_tower_swarm_price = 40
var third_tower_max_swarm_price = 50
var third_tower_max_swarm_upgrade = 2

# Healer
var forth_tower_price = 100
var forth_tower_swarm_price = 25
var forth_tower_max_swarm_price = 50
var forth_tower_max_swarm_upgrade = 1

var collector_price = 50
var miner_price = 50


func _ready():
	EventBus.connect("add_gold", self, "add_gold_to_ressource")
	pass
	
func add_gold_to_ressource(amount):
	gold_ressource = gold_ressource + amount
	EventBus.emit_signal("gold_amount_changed")
	pass
