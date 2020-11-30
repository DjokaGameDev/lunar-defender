extends Node

var dic : Dictionary = {}

var tank1_number = 0
var tank2_number = 0
var tank3_number = 0
var tank4_number = 0
var ship1_number = 0
var boss1_number = 0

func _ready():
	EventBus.connect("add_enemy", self, "add_enemy")
	EventBus.connect("remove_enemy", self, "remove_enemy")
	
	$music/MusicBase.play()
	$music/MusicEnemy1.play()
	$music/MusicEnemy2.play()
	$music/MusicEnemy3.play()
	$music/MusicEnemy4.play()
	#$music/MusicEnemy5.play()
	$music/MusicEnemy6.play()
	$music/MusicBoss.play()
	pass
	
func play_sfx(audio_clip : AudioStream, priority : int = 0, pitch : float = 0):
	for child in $sfx.get_children():
		if child.playing == false:
			child.stream = audio_clip
			child.play()
			child.pitch_scale = pitch
			dic[child.name] = priority
			break
	
		if child.get_index() == $sfx.get_child_count() - 1:
#			var priority_player = check_priority(dic, priority) #finds the player with the highest priority
#			var priority_player = find_oldest_player() #finds the oldest player
			var priority_player = check_priority_and_find_oldest(dic, priority) #finds player with same/lowest priority and oldest player
			if priority_player != null:
				$sfx.get_node(priority_player).stream = audio_clip
				$sfx.get_node(priority_player).play()
				$sfx.get_node(priority_player).pitch_scale = pitch
			else:
				print("priority player is null")
	pass

#playes at most 3 sounds at the same time, in a lot of cases bad, because you get less sound feedback.
#execept when you want to restrict the amount of sounds, for example crashes/destructions/debris
func check_priority(_dic : Dictionary, _priority):
	var prio_list : Array = []
	
	for key in _dic:
		if _priority > _dic[key]:
			prio_list.append(key)#append key(sfx_player.name) to the array
	
	#get the lowest priority from prio_list
	var last_prio = null
	for key in prio_list:
		if last_prio == null:
			last_prio = key
			continue
		if _dic[key] < _dic[last_prio]:
			last_prio = key
	return last_prio
	pass

#playes new sounds all the time, bad if you have important sound, wich you liked to play
func find_oldest_player():
	var last_child = null
	
	for child in $sfx.get_children():
		if last_child == null:
			last_child = child
			continue
		#find player wich played the longest
		if child.get_playback_position() > last_child.get_playback_position():
			last_child = child
	
	return last_child.name
	pass
	
#good for all types of situations, important sound get played most of the time and sounds doesn't get get
#swallowed up most of the time
func check_priority_and_find_oldest(_dic, _priority): #1,3,1 == 1
	var prio_list : Array = []
	for key in _dic: 
		if _priority >= _dic[key]:
			prio_list.append(key) #append key(sfx_player.name) with same/lower priority to an array
	
	#find oldest 
	if prio_list.empty():
		return null
	var oldest_player = prio_list[0]
	for i in range(1, prio_list.size() -1):
		if $sfx.get_node(oldest_player).get_playback_position() < $sfx.get_node(prio_list[i]).get_playback_position():
			oldest_player = prio_list[i]

	return oldest_player
	pass
	
	###### Here is a little coding challenge  #######
#func lowest_priority_and_oldest(_dic, _priority):
	#make prio_list
	#append same/lower priority to prio_list
	#get the lowest priority
	#get all player with the same lowest priority
	#if there is more then 1 player
	#get the oldest player from the lowest priority players

func play_music(music_clip : AudioStream):
	if $music/music_player_1.playing == true:
		$music/music_player_1/Tween.interpolate_property($music/music_player_1, 'volume_db', $music/music_player_1.volume_db, -30, 5, Tween.TRANS_QUART, Tween.EASE_OUT)
		$music/music_player_2/Tween.interpolate_property($music/music_player_2, 'volume_db', $music/music_player_2.volume_db, 0, 5, Tween.TRANS_QUART, Tween.EASE_OUT)
		
		$music/music_player_2.stream = music_clip
		$music/music_player_2.play()
		
		$music/music_player_1/Tween.start()
		$music/music_player_2/Tween.start()
		yield($music/music_player_1/Tween,"tween_all_completed")
		$music/music_player_1.stop()
		
	elif $music/music_player_2.playing == true:
		$music/music_player_2/Tween.interpolate_property($music/music_player_2, 'volume_db', $music/music_player_2.volume_db, -30, 5, Tween.TRANS_QUART, Tween.EASE_OUT)
		$music/music_player_1/Tween.interpolate_property($music/music_player_1, 'volume_db', $music/music_player_1.volume_db, 0, 5, Tween.TRANS_QUART, Tween.EASE_OUT)
		
		$music/music_player_1.stream = music_clip
		$music/music_player_1.play()
		
		$music/music_player_2/Tween.start()
		$music/music_player_1/Tween.start()
		yield($music/music_player_2/Tween,"tween_all_completed")
		$music/music_player_2.stop()
		pass
	else:
		$music/music_player_1/Tween.interpolate_property($music/music_player_1, 'volume_db', $music/music_player_1.volume_db, 0, 5, Tween.TRANS_QUART, Tween.EASE_OUT)
		$music/music_player_1/Tween.start()
		$music/music_player_1.stream = music_clip
		$music/music_player_1.play()
		pass
	pass

func add_enemy(type):
	match(type):
		global.enemy_type.ENEMY_TANK1:
			tank1_number = tank1_number + 1
			if tank1_number == 1:
				$music/MusicEnemy1/Tween.interpolate_property($music/MusicEnemy1, 'volume_db', $music/MusicEnemy1.volume_db, 0, 6, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy1/Tween.start()
		global.enemy_type.ENEMY_TANK2:
			tank2_number = tank2_number + 1
			if tank2_number == 1:
				$music/MusicEnemy2/Tween.interpolate_property($music/MusicEnemy2, 'volume_db', $music/MusicEnemy2.volume_db, 0, 6, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy2/Tween.start()
		global.enemy_type.ENEMY_TANK3:
			tank3_number = tank3_number + 1
			if tank3_number == 1:
				$music/MusicEnemy4/Tween.interpolate_property($music/MusicEnemy4, 'volume_db', $music/MusicEnemy4.volume_db, 0, 6, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy4/Tween.start()
		global.enemy_type.ENEMY_TANK4:
			tank4_number = tank4_number + 1
			if tank4_number == 1:
				$music/MusicEnemy5/Tween.interpolate_property($music/MusicEnemy5, 'volume_db', $music/MusicEnemy5.volume_db, 0, 6, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy5/Tween.start()
		global.enemy_type.ENEMY_SHIP1:
			ship1_number = ship1_number + 1
			if ship1_number == 1:
				$music/MusicEnemy3/Tween.interpolate_property($music/MusicEnemy3, 'volume_db', $music/MusicEnemy3.volume_db, 0, 6, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy3/Tween.start()
		global.enemy_type.ENEMY_BOSS1:
			boss1_number = boss1_number + 1
			if boss1_number == 1:
				$music/MusicBoss/Tween.interpolate_property($music/MusicBoss, 'volume_db', $music/MusicBoss.volume_db, 0, 6, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicBoss/Tween.start()
		_:
			pass
	pass
	
func remove_enemy(type):
	match(type):
		global.enemy_type.ENEMY_TANK1:
			tank1_number = tank1_number - 1
			if tank1_number == 0:
				$music/MusicEnemy1/Tween.interpolate_property($music/MusicEnemy1, 'volume_db', $music/MusicEnemy1.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy1/Tween.start()
		global.enemy_type.ENEMY_TANK2:
			tank2_number = tank2_number - 1
			if tank2_number == 0:
				$music/MusicEnemy2/Tween.interpolate_property($music/MusicEnemy2, 'volume_db', $music/MusicEnemy2.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy2/Tween.start()
		global.enemy_type.ENEMY_TANK3:
			tank3_number = tank3_number - 1
			if tank3_number == 0:
				$music/MusicEnemy4/Tween.interpolate_property($music/MusicEnemy4, 'volume_db', $music/MusicEnemy4.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy4/Tween.start()
		global.enemy_type.ENEMY_TANK4:
			tank4_number = tank4_number - 1
			if tank4_number == 0:
				$music/MusicEnemy5/Tween.interpolate_property($music/MusicEnemy5, 'volume_db', $music/MusicEnemy5.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy5/Tween.start()
		global.enemy_type.ENEMY_SHIP1:
			ship1_number = ship1_number - 1
			if ship1_number == 0:
				$music/MusicEnemy3/Tween.interpolate_property($music/MusicEnemy3, 'volume_db', $music/MusicEnemy3.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicEnemy3/Tween.start()
		global.enemy_type.ENEMY_BOSS1:
			boss1_number = boss1_number - 1
			if boss1_number == 0:
				$music/MusicBoss/Tween.interpolate_property($music/MusicBoss, 'volume_db', $music/MusicBoss.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
				$music/MusicBoss/Tween.start()
		_:
			pass
	pass

func reset_music():
	$music/MusicEnemy1/Tween.interpolate_property($music/MusicEnemy1, 'volume_db', $music/MusicEnemy1.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
	$music/MusicEnemy1/Tween.start()
	$music/MusicEnemy2/Tween.interpolate_property($music/MusicEnemy2, 'volume_db', $music/MusicEnemy2.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
	$music/MusicEnemy2/Tween.start()
	$music/MusicEnemy4/Tween.interpolate_property($music/MusicEnemy4, 'volume_db', $music/MusicEnemy4.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
	$music/MusicEnemy4/Tween.start()
	$music/MusicEnemy5/Tween.interpolate_property($music/MusicEnemy5, 'volume_db', $music/MusicEnemy5.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
	$music/MusicEnemy5/Tween.start()
	$music/MusicEnemy3/Tween.interpolate_property($music/MusicEnemy3, 'volume_db', $music/MusicEnemy3.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
	$music/MusicEnemy3/Tween.start()
	$music/MusicBoss/Tween.interpolate_property($music/MusicBoss, 'volume_db', $music/MusicBoss.volume_db, -80, 10, Tween.TRANS_QUART, Tween.EASE_OUT)
	$music/MusicBoss/Tween.start()
	
	tank1_number = 0
	tank2_number = 0
	tank3_number = 0
	tank4_number = 0
	ship1_number = 0
	boss1_number = 0
	pass
