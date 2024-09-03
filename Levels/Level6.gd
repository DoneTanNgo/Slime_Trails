extends Node2D

func _ready():
	var music = MusicPlayer.get_stream()
	Stats.last_lvl = "res://Levels/Level6.tscn"
	if(music != str("res://Sound/mus_Final.mp3")):
		MusicPlayer.play_music("res://Sound/mus_Final.mp3")
	Stats.ammo = 30
	$boss/AnimationPlayer.play("appear")
	yield($boss/AnimationPlayer,"animation_finished")
	$Timer.start()
	$Timer2.start()
	$Timer.x_range_min = -1532
	$Timer.x_range_max = 1450
	$Timer.y_range_min = -450
	$Timer.y_range_max = 1114
	$Timer2.x_range_min = -1532
	$Timer2.x_range_max = 1450
	$Timer2.y_range_min = -450
	$Timer2.y_range_max = 1114
