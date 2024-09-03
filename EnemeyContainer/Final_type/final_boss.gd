extends KinematicBody2D
var bullet_scene = load("res://EnemeyContainer/bullets/mage_bullets.tscn")
var fire_drops = load("res://EnemeyContainer/bullets/fire_drops.tscn")
var beam_slash_proj = load("res://EnemeyContainer/bullets/beam_slash.tscn")
onready var t1 = get_node("t1")
onready var sword1 = get_node("Lower/sword1")
onready var mage_position_bullets = get_node("Lower/mage_shots_position")
onready var move_timer = get_node("move_timer")
onready var laser_axis = get_node("Lower/laser_axis")
signal teleport_finished
var current_boss = 0
var currently_moving = false
var switch = false
var velocity = Vector2.ZERO
var run_speed = 500
var charge_speed = 1100
var max_hp = 700
var cur_hp = 700
var can_shoot = true
var can_move = true
var player
var temp_position
var direction
var charging = false
var time = 4
var sword_attack = false
var temp_x_value = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Lower/laser_axis/fire_breath.firing_my_laser()
	$Lower/laser_axis/fire_breath.firing_my_laser()
	match current_boss:
		0:
			$AnimationPlayer.play("second_walking")
		1:
			$AnimationPlayer.play("third_walking")
		2:
			$AnimationPlayer.play("fourth_walking")
	EnemeyStats.current_Hp = 700
	EnemeyStats.max_Hp = 700
	move_timer.start(4)

func _process(delta):
	$CanvasLayer/Label.text = "Move Timer: %f" % [move_timer.time_left]
	player = get_tree().get_nodes_in_group("player_group")[0]
	if(player):
		if(can_shoot&&current_boss>=1):
			print("sword_movement")
			sword1.look_at(Vector2(player.position))
		if(player&&can_move&&!charging&&current_boss>=1):
			print("walking")
			velocity = position.direction_to(player.position) * run_speed
			velocity = move_and_slide(velocity)
			
		elif(charging):
			print("charging")
			velocity = direction * charge_speed
			#velocity.y = position.direction_to(temp_position) * charge_speed
			velocity = move_and_slide(velocity)
		
		
func _choose_one():
	can_shoot = false
	var rand = int(rand_range(0,current_boss+1))
	var rand_fire = int(rand_range(0,9))
	if(rand_fire>=5&&current_boss>=2):
		yield(fire_spit_above(3),"completed")
	match rand:
		0:
			switch = true
			changing_icon()
			var rand_num = int(rand_range(0,3))
			match current_boss:
						0:
							$AnimationPlayer.play("first_spell")
						1:
							$AnimationPlayer.play("second_spell")
						2:
							$AnimationPlayer.play("third_spell")
			yield($AnimationPlayer,"animation_finished")
			match rand_num:
				0:
					yield(straight_triple_shot(3),"completed")
				1:
					yield(throwup_shot(4),"completed")
				2:
					yield(wiggles_shot(8),"completed")
		1:
			switch = false
			changing_icon()
			var rand_num = int(rand_range(0,2))
			print(rand_num)
			match rand_num:
				0:
					yield(charge(),"completed")
				1:
					yield(beam_slash(),"completed")
		2:
			var rand_num = int(rand_range(0,2))
			match rand_num:
				0:
					yield(fire_spit_above(2),"completed")
				1:
					yield(left_gun_out(3,0.5),"completed")
	match current_boss:
		0:
			$AnimationPlayer.play("second_walking")
		1:
			$AnimationPlayer.play("third_walking")
		2:
			$AnimationPlayer.play("fourth_walking")
	can_shoot = true

func cur_first_boss_movement():
	
	var cur_position = owner.get_node("boss_position_%s" % [int(rand_range(1,14))])
	var v = Vector2.ZERO
	var current_x_value = temp_x_value
	temp_x_value += 1
	if(!currently_moving):
		while(!int(global_position.x)==int(cur_position.global_position.x)&&!int(global_position.y)==int(cur_position.global_position.y)&&!sword_attack):
			currently_moving = true
			can_move = false
			var y = Timer.new() 
			y.set_wait_time(0.01) 
			add_child(y)
			y.start()
			print("movement %f" % [current_x_value])
			yield(y, "timeout")
			y.queue_free()
			if(abs(int(global_position.x)-int(cur_position.global_position.x))<25&&abs(int(global_position.y)-int(cur_position.global_position.y))<25):
				v = global_position.direction_to(cur_position.global_position)  * 50
			else:
				v = global_position.direction_to(cur_position.global_position)  * 700
	#		position = lerp(global_position,cur_position.global_position,500)
			v = move_and_slide(v)
	currently_moving = false

func attack_teleport(num):
	var cur_position = owner.get_node("boss_position_%s" % [int(rand_range(1,14))])
	can_move = false
	for x in num:
		cur_position = owner.get_node("boss_position_%s" % [int(rand_range(1,14))])
		$smoke.emitting = true
		var y = Timer.new() 
		y.set_wait_time(0.7) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		global_position = cur_position.global_position
		y.start(0.3)
		yield(y, "timeout")
		y.queue_free()
		$smoke.emitting = false
	can_move = true

func changing_icon():
	if(switch):
		$CanvasLayer/weapon1.frame = 0
		$CanvasLayer/weapon2.frame = 1
	else:
		$CanvasLayer/weapon1.frame = 1
		$CanvasLayer/weapon2.frame = 0

func straight_triple_shot(time):
	print("triple_shot")
	can_move = false
	var rand_tele = int(rand_range(0,6))
	if(current_boss>=1&&rand_tele>=3):
		attack_teleport(rand_range(0,4))
		can_move = false
	elif(!sword_attack):
		cur_first_boss_movement()
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	var p = get_tree().get_nodes_in_group("player_group")[0]
	mage_position_bullets.look_at(Vector2(p.position))
	while(int(t.time_left)>0&&cur_hp>0):
		can_move = false
		var y = Timer.new() 
		y.set_wait_time(0.1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		y.queue_free()
		for angle in[-30, -10, 0, 10, 30]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			owner.add_child(b)
			b.transform = mage_position_bullets.global_transform
			b.rotation = mage_position_bullets.rotation + radians
	t.queue_free()
	can_move = true

func wiggles_shot(time) -> void:
	print("wiggles shot")
	can_move = false
	var rand_tele = int(rand_range(0,6))
	if(current_boss>=1&&rand_tele>=3):
		attack_teleport(rand_range(0,4))
		can_move = false
	elif(!sword_attack):
		cur_first_boss_movement()
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()

	var rot = int(rand_range(1,5))
	while(int(t.time_left)>0&&cur_hp>0):
		can_move = false
#		if(GlobalScript._yield_time(0.03)):
		var y = Timer.new() 
		y.set_wait_time(0.03) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		y.queue_free()
		mage_position_bullets.rotate(rot) #Change Pattern of Projectil
		var b = bullet_scene.instance()
		owner.add_child(b)
		b.transform = mage_position_bullets.global_transform
		b.rotation = mage_position_bullets.rotation
	t.queue_free()


func throwup_shot(time) -> void:
	print("throwup_shot")
	can_move = false
	var rand_tele = int(rand_range(0,6))
	if(current_boss>=1&&rand_tele>=3):
		attack_teleport(rand_range(0,4))
		can_move = false
	elif(!sword_attack):
		cur_first_boss_movement()
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):
		can_move = false
		var y = Timer.new() 
		y.set_wait_time(0.5) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		y.queue_free()
		for angle in[rand_range(-35.0,-30.0),rand_range(-30.0,-20.0), rand_range(-20.5,-10.5), rand_range(-5.0,-0.0), 0,rand_range(35.0,30.0),rand_range(30.0,20.0), rand_range(20,0), rand_range(10.0,0.0)]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			owner.add_child(b)
			b.transform = mage_position_bullets.global_transform
			var p = get_tree().get_nodes_in_group("player_group")[0]
			mage_position_bullets.look_at(Vector2(p.position))
			b.rotation = mage_position_bullets.rotation + radians
	t.queue_free()
	can_move = true
	
#Knight Movelist

func charge() -> void:
	sword_attack = true
	match current_boss:
		1:
			$AnimationPlayer.play("second_charging")
		2:
			$AnimationPlayer.play("third_charging")
	yield($AnimationPlayer,"animation_finished")
	can_move = false
	var rand_tele = int(rand_range(0,6))
	if(current_boss>=1&&rand_tele>=3):
		yield(attack_teleport(rand_range(0,3)),"completed")
	var y = Timer.new()
	y.set_wait_time(0.75)
	add_child(y)
	y.start()
	yield(y,"timeout")
	
	if(cur_hp<max_hp*0.5):
		wiggles_shot(2)
	can_move = true
	sword1.rotation = get_angle_to(player.position)
	temp_position = player.position
	direction = position.direction_to(temp_position)
	charging = true
	sword1.look_at(Vector2(player.position))
	$sword.play("multi_thrust")
	
	y.set_wait_time(1.5)
	y.start()
	yield(y,"timeout")
	$sword.stop()
	sword1.rotation = 0
	$sword.play("idle")
	$AnimationPlayer.play("second_walking")
	charging = false
	$sword.play("idle")
	sword_attack = false
	
func beam_slash() -> void:
	sword_attack = true
	can_move = false
	$sword.play("beam_slash")
	var y = Timer.new()
	y.set_wait_time(0.8)
	add_child(y)
	y.start()
	yield(y,"timeout")
	var rand_tele = int(rand_range(0,6))
	if(current_boss>=1&&rand_tele>=3):
		yield(attack_teleport(rand_range(0,4)),"completed")
	can_move = true
	sword1.look_at(Vector2(player.position))
	$sword.play("beam_slash_finish")
	var b = beam_slash_proj.instance()
	if(cur_hp<=max_hp*0.50):
		b.speed = 2000
	elif(cur_hp<=max_hp*0.25):
		b.speed = 2500
	else:
		b.speed = 1800
	throwup_shot(1)
	owner.add_child(b)
	b.transform = sword1.global_transform
	var p = get_tree().get_nodes_in_group("player_group")[0]
	sword1.look_at(Vector2(p.position))
	y.set_wait_time(1.7)
	y.start()
	yield(y,"timeout")
	$sword.play("idle")
	sword1.rotation = 0
	$sword.play("idle")
	sword_attack = false

func multi_thrust() -> void:
	match current_boss:
		1:
			$AnimationPlayer.play("second_blink")
		2:
			$AnimationPlayer.play("third_blink")
	var y = Timer.new()
	y.set_wait_time(0.7)
	add_child(y)
	y.start()
	yield(y,"timeout")	
	sword1.rotation = get_angle_to(player.position)
	sword1.look_at(Vector2(player.position))
	$sword.play("multi_thrust")
	y.set_wait_time(2.5)
	y.start()
	yield(y,"timeout")
	$AnimationPlayer.play("second_walking")
	$sword.play("idle")

func fire_spit_above(time) -> void:
	can_move = false
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
	can_move = true

func left_gun_out(bullet,shottime):
	EnemeyStats.skele_left_option = 1
	can_move = false
	$AnimationPlayer.play("laser_beam")
	var count = bullet
	$AnimationPlayer.stop()
	while(count):
		if(!get_tree().get_nodes_in_group("player_group").empty()):
			var player= get_tree().get_nodes_in_group("player_group")[0]
			t1.visible = true
			t1.global_position = player.global_position
			laser_axis.look_at(player.global_position)
			laser_axis.rotation -= PI/2
			var y = Timer.new() 
			y.set_wait_time(shottime) 
			add_child(y)
			y.start()
			yield(y, "timeout")
			t1.visible = false
			$Lower/laser_axis/fire_breath.firing_my_laser()
			y.set_wait_time(shottime) 
			y.start()
			yield(y, "timeout")
			$Lower/laser_axis/fire_breath.firing_my_laser()
		count -= 1
	can_move = true
	EnemeyStats.skele_left_option = 0

func onHit(damage) -> void:
	cur_hp -= damage
	EnemeyStats.current_Hp = cur_hp
	EnemeyStats.max_Hp = max_hp
	if(cur_hp<= max_hp - max_hp/4&&current_boss==0):
		$sword.play("appear")
		current_boss += 1
		time = 2
	if(cur_hp <= max_hp/2&&current_boss==1):
		current_boss += 1
		time = 1
	
	if(cur_hp<=0):
		Stats.final_boss_finished = true
		GlobalScript._saving()
		yield(get_tree().create_timer(2),"timeout")
		_process(false)
		can_move = false
		$move_timer.stop()
		
		var a = owner.get_children()
		for x in a:
			if(x.is_in_group("enemey_group")):
				x.queue_free()
		var y = Timer.new() 
		y.set_wait_time(0.1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		$AnimationPlayer.play("death_loop")
		var level = preload("res://Levels/credits.tscn")
		Transition.change_scene_to(level)

func _final_move():
	#2,3,4,5
	var temp_ind = 2
	var cur_position = owner.get_node("boss_position_%s" % [temp_ind])
	var v = Vector2.ZERO
	while(!int(global_position.x)==int(cur_position.global_position.x)&&!int(global_position.y)==int(cur_position.global_position.y)):
		can_move = false
		can_shoot = false
		var y = Timer.new() 
		y.set_wait_time(0.01) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		if(abs(int(global_position.x)-int(cur_position.global_position.x))<25&&abs(int(global_position.y)-int(cur_position.global_position.y))<25):
			v = global_position.direction_to(cur_position.global_position)  * 50
		else:
			v = global_position.direction_to(cur_position.global_position)  * 800
		v = move_and_slide(v)

func _movement_spin():
	pass

func _on_move_timer_timeout():
	if(can_shoot):
		print("choose_one")
		_choose_one()
	move_timer.start(time)



func _on_sword_hitbox_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",10)
