extends Node2D
var charger = load("res://EnemeyContainer/Basic_enemies/charge_knight.tscn")
var bb = load("res://EnemeyContainer/bullets/mage_bullets.tscn")
var bb_spiral = load("res://EnemeyContainer/bullets/mage_bullets_spiral.tscn")
var bd = load("res://EnemeyContainer/Basic_enemies/laser_dragon.tscn")
var bd_other = load("res://EnemeyContainer/Basic_enemies/laser_dragon180.tscn")
var timer_active = true
var allow_timer = true
var timer = 0.0
var can_shoot = true
var get_off = false
var finished = false

func _ready():
	Stats.last_lvl = "res://Levels/Level4.tscn"
	var music = MusicPlayer.get_stream()
	if(music != str("res://Sound/mus_Falling.mp3")):
		MusicPlayer.play_music("res://Sound/mus_Falling.mp3")
	Stats.ammo = 9999
	Stats.current_Hp = Stats.max_Hp
	$"Player/Complete_GUI/CanvasLayer2/Enemey_UI".visible = false
	$Player/Light2D.visible = true
	$Player.flashlight = true
	$Player.falling = true
	Stats.last_lvl = "res://Levels/Level4.tscn"
	$CanvasModulate.color = Color(0.001,0.001,0.001)
	$Timer.start(150)
	$Player.environmental_spd.y += 200
	

func _process(delta):
	$Cave1.position.y -= 1000*delta
	$Cave2.position.y -= 1000*delta
	if($Cave1.position.y<-4044):
		$Cave1.position.y = 3270
	if($Cave2.position.y<-4044):
		$Cave2.position.y = 3270
	if(finished&&$ground.position.y > 852):
		$ground.position.y -= 1200*delta
	$CanvasLayer/Label.text = "Time: %s"%[str($Timer.time_left).pad_decimals(0)]
	if (timer_active && allow_timer):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			if(can_shoot):
				choose_one()
			start_timer()
	
			
func start_timer() -> void:
	timer = 4.5
	timer_active = true

func choose_one() -> void:
	var num = int(rand_range(0,5))
	if(!finished):
		if($Timer.time_left>120):
			match num:
				0:
					spawn_chargers()
				1:
					spawn_bd()
				2:
					spawn_bd2()
				3:
					bb_spray(3)
				4:
					bb_shotgun(3)
		elif($Timer.time_left>90):
			match num:
				0:
					if(get_tree().get_nodes_in_group("small_group").empty()):
						spawn_chargers()
						var y = Timer.new()
						y.set_wait_time(1)
						add_child(y)
						y.start()
						yield(y,"timeout")
						spawn_chargers()
				1:
					spawn_bd()
				2:
					spawn_bd2()
				3:
					bb_spray(5)
				4:
					bb_shotgun(5)
		else:
			match num:
				0:
					if(get_tree().get_nodes_in_group("small_group").empty()):
						spawn_chargers()
						var y = Timer.new()
						y.set_wait_time(1)
						add_child(y)
						y.start()
						yield(y,"timeout")
						spawn_chargers()
				1:
					spawn_bd()
				2:
					spawn_bd2()
				3:
					bb_shotgun(3)
					bb_shotgun(3)
				4:
					bb_spray(3)
					bb_spray(3)
	

func spawn_chargers() -> void:
	var c = charger.instance()
	add_child(c)
	c.global_transform = $Knightspawn.global_transform
	
func spawn_bd() -> void:
	var b = bd_other.instance()
	add_child(b)
	b.global_position = $Left.global_position
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var p = get_tree().get_nodes_in_group("player_group")[0]
		b.global_position.y = p.position.y
	else:
		pass

func spawn_bd2() -> void:
	var b = bd.instance()
	add_child(b)
	b.global_position = $Right.global_position
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var p = get_tree().get_nodes_in_group("player_group")[0]
		b.global_position.y = p.position.y
	else:
		pass
	
func bb_spray(time) -> void:
	can_shoot = false
	var t = Timer.new() 
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	var num = int(rand_range(0,4))
	while(int(t.time_left)>0):
		yield(get_tree().create_timer(0.1), "timeout")
		var radians = deg2rad(rand_range(-45,45))
		var b = bb.instance()
		b.speed = 350
		add_child(b)
		match num:
			0:
				b.transform = $Left.global_transform
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Left.look_at(Vector2(p.position))
				b.rotation = $Left.rotation + radians
				enable_lights(num)
			1:
				b.transform = $Right.global_transform
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Right.look_at(Vector2(p.position))
				b.rotation = $Right.rotation + radians
				enable_lights(num)
			2:
				b.transform = $Up.global_transform
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Up.look_at(Vector2(p.position))
				b.rotation = $Up.rotation + radians
				enable_lights(num)
			3: 
				b.transform = $Down.global_transform
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Down.look_at(Vector2(p.position))
				b.rotation = $Down.rotation + radians
				enable_lights(num)
	t.queue_free()
	can_shoot = true
	
func bb_shotgun(time) -> void:
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	var num = int(rand_range(0,4))
	while(int(t.time_left)>0):
		yield(get_tree().create_timer(0.8), "timeout")
		for angle in[-35, -22.5, -10, 0, 10, 22.5, 35]:
			var radians = deg2rad(angle)
			var b = bb.instance()
			add_child(b)
			b.speed = 400
			match num:
				0:
					b.transform = $Left.global_transform
					var p = get_tree().get_nodes_in_group("player_group")[0]
					$Left.look_at(Vector2(p.position))
					b.rotation = $Left.rotation + radians
					enable_lights(num)
				1:
					b.transform = $Right.global_transform
					var p = get_tree().get_nodes_in_group("player_group")[0]
					$Right.look_at(Vector2(p.position))
					b.rotation = $Right.rotation + radians
					enable_lights(num)
				2:
					b.transform = $Up.global_transform
					var p = get_tree().get_nodes_in_group("player_group")[0]
					$Up.look_at(Vector2(p.position))
					b.rotation = $Up.rotation + radians
					enable_lights(num)
				3: 
					b.transform = $Down.global_transform
					var p = get_tree().get_nodes_in_group("player_group")[0]
					$Down.look_at(Vector2(p.position))
					b.rotation = $Down.rotation + radians
					enable_lights(num)
	t.queue_free()
	can_shoot = true
	
func _on_Area2D_area_entered(area):
	$Player/Camera2D.current = true
func enable_lights(dir: int):
	match dir:
		0:
			$Left/Light2D.enabled = true
			var y = Timer.new()
			y.set_wait_time(1)
			add_child(y)
			y.start()
			yield(y,"timeout")
			$Left/Light2D.enabled = false
		1:
			$Right/Light2D.enabled = true
			var y = Timer.new()
			y.set_wait_time(1)
			add_child(y)
			y.start()
			yield(y,"timeout")
			$Right/Light2D.enabled = false
		2:
			$Up/Light2D.enabled = true
			var y = Timer.new()
			y.set_wait_time(1)
			add_child(y)
			y.start()
			yield(y,"timeout")
			$Up/Light2D.enabled = false
		3:
			$Down/Light2D.enabled = true
			var y = Timer.new()
			y.set_wait_time(1)
			add_child(y)
			y.start()
			yield(y,"timeout")
			$Down/Light2D.enabled = false

func _on_Timer_timeout():
	$Player.disabled = true
	$Player/Light2D.visible = false
	$Player/Area2D/CollisionShape2D2.disabled = true
	$Player/CollisionShape2D.disabled = true
	$Player.platforming = true
	finished = true
	Stats.falling_finished = true
	GlobalScript._saving()
	yield(get_tree().create_timer(10),"timeout")
	$Player/Light2D.visible = true
	if(Stats.demo):
		$CanvasLayer/Sprite.visible = true
		var y = Timer.new()
		y.set_wait_time(6)
		add_child(y)
		y.start()
		yield(y,"timeout")
		Stats.falling_finished = false
		Transition.change_scene("res://Menu/Level_map_1.tscn")
	else:
		Transition.change_scene("res://Menu/Level_map_2.tscn")
	
	
