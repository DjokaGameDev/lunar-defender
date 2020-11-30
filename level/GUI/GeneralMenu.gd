extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_StartButton_pressed():
	global.current_phase = 0
	global.gold_ressource = 1000
	audio_manager.reset_music()
	get_tree().change_scene("res://level/Battlefield/BattleField.tscn")
	pass # Replace with function body.


func _on_OptionButton_pressed():
	$AudioMenu.visible = true
	pass # Replace with function body.


func _on_CreditButton_pressed():
	$Credit.visible = true
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.
