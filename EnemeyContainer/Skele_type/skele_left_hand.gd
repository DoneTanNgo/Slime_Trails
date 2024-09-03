extends KinematicBody2D
onready var ani_player = get_node("ani_Left_hand")
onready var shadow = get_node("Left_Arm_axis/Shadow")
onready var f_index = get_node("Left_Arm_axis/Left_Arm/index")
onready var f_middle = get_node("Left_Arm_axis/Left_Arm/middle")
onready var f_pinky = get_node("Left_Arm_axis/Left_Arm/pinky")
onready var f_thumb = get_node("Left_Arm_axis/Left_Arm/thumb")
onready var f_index_laser = get_node("Left_Arm_axis/Left_Arm/index/laser")
onready var f_middle_laser = get_node("Left_Arm_axis/Left_Arm/middle/laser")
onready var f_pinky_laser = get_node("Left_Arm_axis/Left_Arm/pinky/laser")
onready var f_thumb_laser = get_node("Left_Arm_axis/Left_Arm/thumb/laser")
onready var hurtbox = get_node("Left_Arm_axis/Left_Arm/left_arm_area/CollisionShape2D2")
onready var arm = get_node("Left_Arm_axis/Left_Arm")
onready var axis = get_node("Left_Arm_axis")
onready var t1 = get_node("t1")
onready var t2 = get_node("t2")
onready var collsion_main = get_node("body")
var finger_bullet = load("res://EnemeyContainer/bullets/placeholder_bullets.tscn")
var walking = true
var cur_hp = 300
var max_hp = 300
var run_speed = 500
var in_area = false
var timer_active = true
var timer = 5.0
var during_attack = false
var can_hit = true
var TIMER_TIME = 8
var stop = false
signal found_player
var velocity = Vector2.ZERO

func _ready():
	pass
	
func _process(delta):
	collsion_main.global_position = $Left_Arm_axis/Left_Arm/damage_zone/twobody.global_position
	collsion_main.rotation = $Left_Arm_axis/Left_Arm.rotation + $Left_Arm_axis.rotation
#	print(during_attack)
#	print($Left_Arm_axis.rotation)
	if (timer_active&&!stop):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			print(can_hit)
			if(can_hit):
				choose_one()
			start_timer()
	
#Option: 1,shot 2slam,
func choose_one():
	ani_player.stop()
	if(!EnemeyStats.skele_right_down):
		if(EnemeyStats.skele_left_option<2):
			var num = int(rand_range(1,4))
			match num:
				1:
					left_gun_out(3,0.5)
				2:
					left_hand_slam(true,3,5)
				3:
					_rocket_punch(3)
		else:
			var num = int(rand_range(1,3))
			match num:
				1:
					left_gun_out(3,0.5)
				2:
					_rocket_punch(3)
	else:
		if(EnemeyStats.skele_left_option<2):
			var num = int(rand_range(1,4))
			match num:
				1:
					left_gun_out(5,0.3)
				2:
					left_hand_slam(true,5,4)
				3:
					_rocket_punch(3)
		else:
			var num = int(rand_range(1,3))
			match num:
				1:
					left_gun_out(5,0.2)
				2:
					_rocket_punch(3)
		
func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("player_group")[0]
	if(player&&walking&&can_hit&&!stop):
		if(global_position.x<player.global_position.x):
			run_speed = 650
		else:
			run_speed = 250
		if(in_area):
			ani_player.play("flick")
			walking = false
			yield(ani_player,"animation_finished")
			walking = true
			$Left_Arm_axis/flick_hurtbox/CollisionShape2D.disabled = true
		else:
			ani_player.play("walk")
		velocity = global_position.direction_to(player.global_position)  * run_speed
		velocity = move_and_slide(velocity)

func left_hand_slam(finger,rank,time):
	during_attack = true
	EnemeyStats.skele_left_option = 2
	walking = false
	can_hit = false
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var player= get_tree().get_nodes_in_group("player_group")[0]
#		$Left_Arm_axis.look_at(x.global_position)
#		$Left_Arm_axis.rotation -= PI/2
		shadow.visible = true
		var t = Timer.new() 
		t.one_shot = true
		t.set_wait_time(time) 
		add_child(t)
		t.start()
		ani_player.play("hand_rise") 
		yield(ani_player,"animation_finished")
		var run_speed = 500
		while(t.time_left):
			var y = Timer.new() 
			y.set_wait_time(0.01) 
			add_child(y)
			y.start()
			yield(y, "timeout")
			velocity = Vector2.ZERO
			if player:
				velocity = global_position.direction_to(player.global_position) * run_speed
				velocity = move_and_slide(velocity)
		ani_player.play("hand_slam")
		yield(ani_player,"animation_finished")
		var count = rank
		var times = Timer.new()
		times.set_wait_time(100)
		add_child(times)
		times.start()
		if(finger):
			f_index_laser.firing_my_laser()
			f_middle_laser.firing_my_laser()
			f_pinky_laser.firing_my_laser()
			f_thumb_laser.firing_my_laser()
			var y = Timer.new()
			y.one_shot = true
			y.set_wait_time(rank) 
			add_child(y)
			y.start()
			while(y.time_left):
				var z = Timer.new() 
				z.set_wait_time(1.0/rank) 
				add_child(z)
				z.start()
				yield(z,"timeout")
				count -= 1
				if(arm.frame < 14):
					arm.frame += 1
		
		var y = Timer.new()
		y.one_shot = true
		y.set_wait_time(3) 
		add_child(y)
		y.start()
		yield(y,"timeout")
		left_hand_slam_finished(finger)
		during_attack = false

func left_hand_slam_finished(finger):
	if(finger):
		hurtbox.disabled = true
		while(arm.frame != 12):
			var y = Timer.new()
			y.set_wait_time(0.3)
			add_child(y) 
			y.start()
			yield(y, "timeout")
			if(arm.frame>12):
				arm.frame -= 1
		f_index_laser.firing_my_laser()
		f_middle_laser.firing_my_laser()
		f_pinky_laser.firing_my_laser()
		f_thumb_laser.firing_my_laser()
	var y = Timer.new()
	y.one_shot = true
	y.set_wait_time(3) 
	add_child(y)
	y.start()
	yield(y,"timeout")
	reset_look()
	shadow.visible = false
	walking = true
	can_hit = true
	EnemeyStats.skele_left_option = 0
	
func left_gun_out(bullet,shottime):
	EnemeyStats.skele_left_option = 1
	walking = false
	can_hit = false
	arm.frame = 16
	var count = bullet
	ani_player.stop()
	f_middle.position = Vector2(-130.621,62.368)
	arm.position = Vector2(17.615,-26.715)
	while(count):
		if(!get_tree().get_nodes_in_group("player_group").empty()):
			var player= get_tree().get_nodes_in_group("player_group")[0]
			t1.visible = true
			t1.global_position = player.global_position
			axis.look_at(player.position)
			axis.rotation -= PI
			arm.rotation = 0
			var y = Timer.new() 
			y.set_wait_time(shottime) 
			add_child(y)
			y.start()
			yield(y, "timeout")
			t1.visible = false
			f_middle_laser.firing_my_laser()
			y.set_wait_time(shottime) 
			y.start()
			yield(y, "timeout")
			f_middle_laser.firing_my_laser()
		count -= 1
	f_middle.position = Vector2(-136.457,25.975)
	arm.position = Vector2(1.516,-2.299)
	arm.frame = 3
	walking = true
	can_hit = true
	EnemeyStats.skele_left_option = 0
func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func reset_look():
	shadow.visible = false
	hurtbox.disabled = true

func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		$ani_Left_hand.play("death")
		stop = true
		EnemeyStats.skele_left_down = true
		
func _on_player_detect_area_entered(area):
	if(area.is_in_group("player_group")):
		in_area = true


func _on_player_detect_area_exited(area):
	if(area.is_in_group("player_group")):
		in_area = false

func _stop_everything():
	stop = !stop

func _rocket_punch(startup):
	collsion_main.disabled = true
	EnemeyStats.skele_left_option = 3
	var temp_vel = Vector2.ZERO
	walking = false
	can_hit = false
	arm.frame = 16
	ani_player.stop()
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var player= get_tree().get_nodes_in_group("player_group")[0]
		axis.rotation_degrees = 180
		t1.visible = true
		t1.global_position = player.global_position
		var y = Timer.new() 
		y.one_shot = true
		y.set_wait_time(startup) 
		add_child(y)
		y.start()
		ani_player.play("fist")
		while(y.time_left):
			var t = Timer.new() 
			t.one_shot = true
			t.set_wait_time(0.01) 
			add_child(t)
			t.start()
			yield(t,"timeout")
			axis.look_at(player.global_position)
			axis.rotation -= PI
		var dist = global_position.distance_to(player.global_position)
		t1.visible = false
		y.set_wait_time(2)
		y.start()
		run_speed = 2000
		var direction = global_position.direction_to(player.global_position + player.player_vol * (dist/30))
		temp_vel = direction * run_speed
		axis.look_at(player.global_position)
		axis.rotation -= PI
		$Left_Arm_axis/Left_Arm/fist_area/CollisionShape2D.disabled = false
		while(y.time_left):
			var t = Timer.new() 
			t.one_shot = true
			t.set_wait_time(0.01) 
			add_child(t)
			t.start()
			yield(t,"timeout")
			move_and_slide(temp_vel)
	$Left_Arm_axis/Left_Arm/fist_area/CollisionShape2D.disabled = true
	arm.frame = 3
	walking = true
	can_hit = true
	$body.disabled = false
	EnemeyStats.skele_left_option = 0

func _on_flick_hurtbox_body_entered(body):
	if(body.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)

func _on_damage_zone_area_entered(area):
	if(area.is_in_group("player_group")):
		print("true")
		print(!during_attack)
		
	if(area.is_in_group("air_group")&&can_hit):
		$Left_Arm_axis/Left_Arm/damage_zone/CollisionShape2D.set_deferred("disabled",true)
		$Left_Arm_axis/Left_Arm/damage_zone/twobody.set_deferred("disabled",true)
		yield(left_hand_slam(false,3,5),"completed")
		$Left_Arm_axis/Left_Arm/damage_zone/CollisionShape2D.set_deferred("disabled",false)
		$Left_Arm_axis/Left_Arm/damage_zone/twobody.set_deferred("disabled",false)
		
	if(area.is_in_group("player_group")&&!during_attack):
		$"body".set_deferred("disabled",true)
	
		
	if(area.is_in_group("bullet")&&!during_attack):
		$"body".set_deferred("disabled",false)

func _on_damage_zone_area_exited(area):
	if(area.is_in_group("player_group")&&!during_attack&&!stop):
		$body.set_deferred("disabled",true)
	if(area.is_in_group("bullet")&&!during_attack):
		$body.set_deferred("disabled",true)


func _on_fist_area_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
