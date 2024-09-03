extends Node2D
var work = true
func _ready():
	GlobalScript.restart = false
	Stats.last_lvl = "res://Levels/Level1.tscn"
	var music = MusicPlayer.get_stream()
	if(music != str("res://Sound/mus_Mage.mp3")):
		MusicPlayer.play_music("res://Sound/mus_Mage.mp3")
	Stats.ammo = 10
	Stats.current_Hp = Stats.max_Hp
	$Player/Camera2D.current = false
	$Timer.x_range_min = -815
	$Timer.x_range_max = 2500
	$Timer.y_range_min = -200
	$Timer.y_range_max = 1650
	$Timer2.x_range_min = -815
	$Timer2.x_range_max = 2500
	$Timer2.y_range_min = -200
	$Timer2.y_range_max = 1650
	$Player/Light2D.visible = false

func _process(delta):
	if(EnemeyStats.current_Hp<=0&&work):
		work = !work
		Stats.mage_finished = true
		GlobalScript._saving()
		$Player/Area2D/CollisionShape2D2.disabled = true
		$Player.disabled = true
		$Player.moving = false
		$Player.can_shoot = false
		$Enemey/Area2D/CollisionShape2D.disabled = true
		$Enemey/CollisionShape2D2.disabled = true
		var y = Timer.new()
		y.set_wait_time(6)
		add_child(y)
		y.start()
		yield(y,"timeout")
		
		$Player.emit_signal("win")
		
		$Player.position = Vector2(800,850)
		
