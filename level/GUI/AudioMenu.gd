extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	load_volume()
	pass # Replace with function body.

func load_volume():
	print("Loading volume")
	
	var data = PersistenceNode.get_data("audio")
	print(data)
	
	if data.has("Music"):
		$VBoxContainer/MusicVolume/MusicSliderVolume.value = data["Music"]["Volume"]
		#_on_MusicSliderVolume_value_changed(data["Music"]["Volume"])
	if data.has("Effect"):
		$VBoxContainer/EffectVolume/EffectSliderVolume.value = data["Effect"]["Volume"]
		#_on_MusicSliderVolume_value_changed(data["Music"]["Volume"])
	
	#PersistenceNode.save_data("audio")
	#Notifications.notify("Audio saved!")
	pass
	
func save_volume():
	print("Saving volume")
	
	var data = PersistenceNode.get_data("audio")
	print(data)

	data["Music"] = {
		"Volume" : $VBoxContainer/MusicVolume/MusicSliderVolume.value
	}
	data["Effect"] = {
		"Volume" : $VBoxContainer/EffectVolume/EffectSliderVolume.value
	}
	
	PersistenceNode.save_data("audio")
	#Notifications.notify("Audio saved!")
	pass


func _on_MusicSliderVolume_value_changed(value):
	var music_bus = AudioServer.get_bus_index("Music")

	if value < 1:
		AudioServer.set_bus_mute(music_bus, true)
		pass
	else:
		AudioServer.set_bus_mute(music_bus, false)
		AudioServer.set_bus_volume_db(music_bus, value/2.0 - 50.0)
	
	$VBoxContainer/MusicVolume/Value.text = str(value)
	pass # Replace with function body.


func _on_EffectSliderVolume_value_changed(value):
	var sounds_bus = AudioServer.get_bus_index("SFX")

	if value < 1:
		AudioServer.set_bus_mute(sounds_bus, true)
		pass
	else:
		AudioServer.set_bus_mute(sounds_bus, false)
		AudioServer.set_bus_volume_db(sounds_bus, value/2.0 - 50.0)
	
	$VBoxContainer/EffectVolume/Value.text = str(value)
	pass # Replace with function body.


func _on_SaveButton_pressed():
	audio_manager.play_sfx(load("res://assets/audio/sfx/Menu_Navigate_00.wav"), 1, 1)
	save_volume()
	visible = false
	pass # Replace with function body.


func _on_ExitButton_pressed():
	audio_manager.play_sfx(load("res://assets/audio/sfx/Menu_Navigate_00.wav"), 1, 1)
	visible = false
	pass # Replace with function body.
