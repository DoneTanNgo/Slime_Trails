extends KinematicBody2D
var fire_scene = load("res://EnemeyContainer/bullets/fire_bullet.tscn")
var fire_on_scene = load("res://EnemeyContainer/bullets/fire_leftover.tscn")
var fire_drops = load("res://EnemeyContainer/bullets/fire_drops.tscn")
var stone_wall = load("res://EnemeyContainer/Dragon_type/wall.tscn")
var baby_dragons = load("res://EnemeyContainer/Basic_enemies/laser_dragon.tscn")
var baby_dragon_180 = load("res://EnemeyContainer/Basic_enemies/laser_dragon180.tscn")
var baby_dragon_up = load("res://EnemeyContainer/Basic_enemies/laser_dragonUp.tscn")
onready var bd_dragon_timer = get_node("bd_dragon_timer")
var cur_hp = 750.0
var max_hp = 750.0
var timer = 0.0
const TIMER_TIME = 3
var db_timer_time = 7
var rng
var in_left = false
var in_right = false
var easy_mode = false
var timer_active = false
var allow_timer = true
var can_hit = true
var can_bd_fire = true
var b_speed = 500 
var fired = false
var producing = true
var second_phase = false
var during_attack = false
var disabled = false

func _ready():
	EnemeyStats.current_Hp = cur_hp
	EnemeyStats.max_Hp = max_hp
#	$fire_breath.dissapear()
	$"Warning-1png".visible = false
	start_timer()

func _process(delta):
	while(fired&&!disabled):
		if(get_tree().get_nodes_in_group("fire_proj")&&producing):
			producing = false
			var p = get_tree().get_nodes_in_group("fire_proj")
			for x in p:
				leave_fire(x.position)
			var y = Timer.new()
			y.set_wait_time(0.25)
			add_child(y)
			y.start()
			yield(y,"timeout")
			producing = true
		var y = Timer.new()
		y.set_wait_time(5)
		add_child(y)
		y.start()
		yield(y,"timeout")
		fired = false

	if (timer_active && allow_timer && !disabled):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			if(can_hit):
				choose_one()
			start_timer()
			
	

func choose_one() -> void:
	var num = int(rand_range(0,6))
	if(cur_hp>=max_hp/2):
		if(in_left||in_right):
			if(in_left):
				full_arm_swing(true)
			elif(in_right):
				full_arm_swing(false)
		else:
			match num:
				0:
					fire_spit_left(1)
				1:
					fire_spit_above(3)
				2:
					fire_breath(true)
				3:
					fire_breath(false)
				4:
					full_screen_fire_breath(true)
				5:
					full_screen_fire_breath(false)
				6:
					fire_spit_right(1)
	else:
		if(in_left||in_right):
			full_arm_swing(true)
			yield($Arms,"animation_finished")
			full_arm_swing(false)
		else:
			match num:
				0:
					fire_spit_mid(1)
				1:
					fire_spit_above(5)
				2:
					fire_breath(true)
				3:
					fire_breath(false)
				4:
					full_screen_fire_breath(true)
				5:
					full_screen_fire_breath(false)
				6:
					fire_spit_right(1)

func fire_breath(way: bool) -> void:
	during_attack = true
	can_hit = false
	$Arms.play("Laser_coming_out")
	yield($Arms,"animation_finished")
	if(way):
		$Field.play("Warning_Left")
		yield($Field,"animation_finished")
		$fire_breath.fire_moving("left")
	else:
		$Field.play("Warning_Right")
		yield($Field,"animation_finished")
		$fire_breath.fire_moving("right")
	$Arms.play_backwards("Laser_coming_out")
	var y = Timer.new()
	y.set_wait_time(1)
	add_child(y)
	y.start()
	yield(y,"timeout")
	yield($Arms,"animation_finished")
	$Arms.play("rest")
	can_hit = true
	during_attack = false
func _baby_dragon_action():
	if(cur_hp<(max_hp*0.75)&&!disabled&&!cur_hp<0):
		if(cur_hp<(max_hp*0.5)):
			spawn_bd()
			spawn_bd2()
			spawn_bd3()
			db_timer_time = 6
		elif(cur_hp<(max_hp*0.25)):
			spawn_bd()
			spawn_bd2()
			spawn_bd3()
			db_timer_time = 5
		else:
			spawn_bd()
			spawn_bd2()
			db_timer_time = 7

func full_screen_fire_breath(way: bool)-> void:
	during_attack = true
	can_hit = false
	var b = stone_wall.instance()
	$Arms.play("Laser_coming_out")
	yield($Arms,"animation_finished")
	if(way):
		$Field.play("Warning_Right")
		yield($Field,"animation_finished")
		$Field.play("Warning_Left")
		yield($Field,"animation_finished")
		if(!get_tree().get_nodes_in_group("player_group").empty()):
			var p = get_tree().get_nodes_in_group("player_group")[0]
			owner.add_child(b)
			b.position.x = p.position.x + rand_range(-600,600)
			b.position.y = p.position.y + rand_range(-600,600)
		$fire_breath.full_fire_moving("left")
	else:
		$Field.play("Warning_Left")
		yield($Field,"animation_finished")
		$Field.play("Warning_Right")
		yield($Field,"animation_finished")
		if(!get_tree().get_nodes_in_group("player_group").empty()):
			var p = get_tree().get_nodes_in_group("player_group")[0]
			owner.add_child(b)
			b.position.x = p.position.x + rand_range(-600,600)
			b.position.y = p.position.y + rand_range(-600,600)
		$fire_breath.full_fire_moving("right")
	var y = Timer.new()
	y.set_wait_time(1)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$Arms.play_backwards("Laser_coming_out")
	yield($Arms,"animation_finished")
	$Arms.play("rest")
	can_hit = true
	during_attack = false
	
func fire_spit_above(time) -> void:
	during_attack = true
	can_hit = false
	var t = Timer.new() 
	t.set_wait_time(time)
	add_child(t)
	t.start()
	while(int(t.time_left)>0):
		var y = Timer.new()
		y.set_wait_time(0.15)
		add_child(y)
		y.start()
		yield(y,"timeout")
		if(!get_tree().get_nodes_in_group("player_group").empty()):
			var p = get_tree().get_nodes_in_group("player_group")[0]
			var b = fire_drops.instance()
			owner.add_child(b)
			b.position.x = p.position.x + rand_range(-700,700)
			b.position.y = p.position.y + rand_range(-700,700)
	can_hit = true
	during_attack = false

func fire_spit_mid(time) -> void:
	during_attack = true	
	can_hit = false
	$Arms.play("Laser_coming_out")
	yield($Arms,"animation_finished")
	var t = Timer.new() 
	t.set_wait_time(time)
	add_child(t)
	t.start()
	var decay = 1
	while(int(t.time_left)>0):
		b_speed -= 5
		var y = Timer.new()
		y.set_wait_time(0.15)
		add_child(y)
		y.start()
		yield(y,"timeout")
		for angle in[-22.5, -20,-15, -10, -5, 0, 5, 10, 15, 20, 22.5]:
			var radians = deg2rad(angle)
			var b = fire_scene.instance()
			b.speed = b_speed
			b.speed_decay = decay
			owner.add_child(b)
			b.transform = $Neck/Head/Position2D.global_transform
			fired = true
			if(!get_tree().get_nodes_in_group("player_group").empty()):
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Neck/Head/Position2D.look_at(Vector2(452,1063))
			else:
				$Neck/Head/Position2D.look_at(Vector2(0,0))
			b.rotation = $Neck/Head/Position2D.rotation + radians
	t.queue_free()
	$Arms.play_backwards("Laser_coming_out")
	yield($Arms,"animation_finished")
	$Arms.play("rest")
	can_hit = true
	during_attack = false	
func fire_spit_left(time)-> void:
	during_attack = true	
	can_hit = false
	$Arms.play("Laser_coming_out")
	yield($Arms,"animation_finished")
	var t = Timer.new() 
	t.set_wait_time(time)
	add_child(t)
	t.start()
	var decay = 1
	while(int(t.time_left)>0):
		b_speed -= 5
		var y = Timer.new()
		y.set_wait_time(0.15)
		add_child(y)
		y.start()
		yield(y,"timeout")
		for angle in[-44.5,-40,-35,-30, -25, -22.5, -20,-15, -10, -5]:
			var radians = deg2rad(angle)
			var b = fire_scene.instance()
			b.speed = b_speed
			b.speed_decay = decay
			owner.add_child(b)
			b.transform = $Neck/Head/Position2D.global_transform
			fired = true
			if(!get_tree().get_nodes_in_group("player_group").empty()):
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Neck/Head/Position2D.look_at(Vector2(452,1063))
			else:
				$Neck/Head/Position2D.look_at(Vector2(0,0))
			b.rotation = $Neck/Head/Position2D.rotation + radians
	t.queue_free()
	$Arms.play_backwards("Laser_coming_out")
	yield($Arms,"animation_finished")
	$Arms.play("rest")
	can_hit = true
	during_attack = false

func fire_spit_right(time)-> void:
	during_attack = true
	can_hit = false
	$Arms.play("Laser_coming_out")
	yield($Arms,"animation_finished")
	var t = Timer.new() 
	t.set_wait_time(time)
	add_child(t)
	t.start()
	var decay = 1
	while(int(t.time_left)>0):
		b_speed -= 5
		var y = Timer.new()
		y.set_wait_time(0.15)
		add_child(y)
		y.start()
		yield(y,"timeout")
		for angle in[0, 5, 10, 15, 20, 22.5, 44.5, 40, 35, 30, 25]:
			var radians = deg2rad(angle)
			var b = fire_scene.instance()
			b.speed = b_speed
			b.speed_decay = decay
			owner.add_child(b)
			b.transform = $Neck/Head/Position2D.global_transform
			fired = true
			if(!get_tree().get_nodes_in_group("player_group").empty()):
				var p = get_tree().get_nodes_in_group("player_group")[0]
				$Neck/Head/Position2D.look_at(Vector2(452,1063))
			else:
				$Neck/Head/Position2D.look_at(Vector2(0,0))
			b.rotation = $Neck/Head/Position2D.rotation + radians
	t.queue_free()
	$Arms.play_backwards("Laser_coming_out")
	yield($Arms,"animation_finished")
	$Arms.play("rest")
	can_hit = true
	during_attack = false
	

func spawn_bd() -> void:
	var b = baby_dragons.instance()
	add_child(b)
	b.rotate(0)
	b.global_position = $bd_spawn.global_position
	if(cur_hp<(max_hp*0.5)):
		b.can_move = true
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var p = get_tree().get_nodes_in_group("player_group")[0]
		b.global_position.y = p.position.y + rand_range(-200,200)
	else:
		pass

func spawn_bd2() -> void:
	var b = baby_dragon_180.instance()
	add_child(b)
	b.rotate(0)
	b.global_position = $bd_spawn3.global_position
	if(cur_hp<(max_hp*0.25)):
		b.can_move = true
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var p = get_tree().get_nodes_in_group("player_group")[0]
		b.global_position.y = p.position.y + rand_range(-200,200)
	else:
		pass

func spawn_bd3() -> void:
	var b = baby_dragon_up.instance()
	add_child(b)
	b.rotate(0)
	b.global_position = $bd_spawn4.global_position
	if(cur_hp<(max_hp*0.25)):
		b.can_move = true
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var p = get_tree().get_nodes_in_group("player_group")[0]
		b.global_position.x = p.position.x + rand_range(-200,200)
	else:
		pass
	
func full_arm_swing(way: bool) -> void:
	during_attack = true
	can_hit = false
	if(way):
		arm_attack_collision()
		$Arms.play("Left_swing")
	else:
		arm_attack_collision()
		$Arms.play("Right_swing")
	yield($Arms,"animation_finished")
	$Arms.play("rest")
	can_hit = true
	during_attack = false
	

func arm_attack_collision()-> void:
	$Left/Upper/Forearm/forearm/StaticBody2D/CollisionPolygon2D.disabled = true
	$Left/Upper/upper/StaticBody2D/CollisionPolygon2D.disabled = true
	$Right/Upper/Forearm/forearm/StaticBody2D/CollisionPolygon2D.disabled = true
	$Right/Upper/upper/StaticBody2D/CollisionPolygon2D.disabled = true

func leave_fire(positioned):
	var f = fire_on_scene.instance()
	var y = Timer.new()
	y.set_wait_time(0.2)
	add_child(y)
	y.start()
	yield(y,"timeout")
	owner.add_child(f)
	f.position = positioned

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true
	
func onHit(damage) -> void:
	cur_hp -= damage
	EnemeyStats.current_Hp = cur_hp
	EnemeyStats.max_Hp = max_hp
	if(max_hp/2>cur_hp&&!second_phase&&!during_attack):
		second_phase = true
		timer_active = false
		var y = Timer.new()
		y.set_wait_time(10)
		add_child(y)
		y.start()
		yield(y,"timeout")
		timer_active = true
	if(cur_hp<=0):
		$Head_area.active = false
		$Head.play("Death")
		allow_timer = false
		set_process(false)
		set_physics_process(false)
#		yield(get_tree().create_timer(1),"timeout")


func _on_Left_area_detection_area_entered(area):
	if(area.is_in_group("player_group")):
		in_left = true


func _on_Right_area_detectoin_area_entered(area):
	if(area.is_in_group("player_group")):
		in_right = true


func _on_Left_area_detection_area_exited(area):
	if(area.is_in_group("player_group")):
		in_left = false


func _on_Right_area_detectoin_area_exited(area):
	if(area.is_in_group("player_group")):
		in_right = false

func _on_HitBox_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",10)


func _on_bd_dragon_timer_timeout():
	bd_dragon_timer.start(db_timer_time)
	_baby_dragon_action()
