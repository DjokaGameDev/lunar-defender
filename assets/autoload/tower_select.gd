extends Node

# Signals
signal select_tower(tower)

# Variables
var holding_tower = null
var tower_offset = Vector2(0, 0);
var selected_tower = null
var selecting_collect_target = null


func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	connect("select_tower", self, "on_select_tower")
	pass

func _process(_delta):
	if selected_tower == null:
		var building_area = get_node_or_null("../BattleField/Ground/SelectedBuilding")
		if building_area != null:
			building_area.visible = false
	pass

func _unhandled_input(event : InputEvent):
		#print("input process de merde")
		if event is InputEventMouseMotion:
				if holding_tower && holding_tower.picked:
						holding_tower.global_position = get_viewport().canvas_transform.affine_inverse().xform(event.position) - tower_offset;
		elif event is InputEventMouseButton and event.is_pressed():
			match event.button_index:
				BUTTON_LEFT:
					# left button clicked
					if selecting_collect_target:
						pass
					else:
						if holding_tower && holding_tower.picked:
							#print("holding")
							if holding_tower.drop_on_ground():
								match holding_tower.type:
									global.tower_type.TOWER_LASER:
										#global.gold_ressource = global.gold_ressource - global.first_tower_price
										EventBus.emit_signal("add_gold", -global.first_tower_price)
									global.tower_type.TOWER_BOMB:
										#global.gold_ressource = global.gold_ressource - global.second_tower_price
										EventBus.emit_signal("add_gold", -global.second_tower_price)
									global.tower_type.TOWER_THUNDER:
										#global.gold_ressource = global.gold_ressource - global.third_tower_price
										EventBus.emit_signal("add_gold", -global.third_tower_price)
									global.tower_type.TOWER_HEAL:
										#global.gold_ressource = global.gold_ressource - global.forth_tower_price
										EventBus.emit_signal("add_gold", -global.forth_tower_price)
									_:
										#global.gold_ressource = global.gold_ressource - global.first_tower_price
										EventBus.emit_signal("add_gold", -global.first_tower_price)
								holding_tower = null
								EventBus.emit_signal("unholding_tower")
						else:
							#print("Pas de holding")
							pass
						
					if selected_tower:
						pass
				BUTTON_RIGHT:
					# right button clicked
					if holding_tower && holding_tower.picked:
						holding_tower.queue_free()
						holding_tower = null
						EventBus.emit_signal("unholding_tower")
					
					if selected_tower:
						#print("stop selecting tower")
						selected_tower.tower_unselected()
						selected_tower = null
						get_node("../BattleField/Ground/SelectedBuilding").visible = false
						pass
						
					if selecting_collect_target:
						selecting_collect_target = null
						pass
		else:
			pass

func on_select_tower(tower):
	if selected_tower:
		selected_tower.tower_unselected()
	selected_tower = tower
	selected_tower.tower_selected()
	var building_area = get_node("../BattleField/Ground/SelectedBuilding")
	building_area.rect_size = Vector2(tower.tower_size * 2.0, tower.tower_size * 2.0)
	building_area.rect_global_position = tower.global_position + Vector2(-tower.tower_size / 2.0,-tower.tower_size / 2.0)
	building_area.visible = true
	building_area.get_node("AnimationPlayer").play("idle")
	pass
