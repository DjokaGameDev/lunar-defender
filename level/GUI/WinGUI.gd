extends CanvasLayer

#func _input(event):
#	if event is InputEventKey:
#		if event.is_pressed():
#			if event.scancode == KEY_ESCAPE:
#				set_pause()
#				pass
#	pass
	
func set_pause():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	$Rect.visible = new_pause_state


func _on_ExitButton_pressed():
	set_pause()
	get_tree().change_scene("res://level/GUI/GeneralMenu.tscn")
	pass # Replace with function body.
