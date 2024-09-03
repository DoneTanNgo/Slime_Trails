extends KinematicBody2D
onready var ani_player = get_node("ani_right_hand")
onready var shadow = get_node("Right_Arm_axis/Shadow")
onready var f_index = get_node("Right_Arm_axis/Right_Arm/index")
onready var f_middle = get_node("Right_Arm_axis/Right_Arm/middle")
onready var f_pinky = get_node("Right_Arm_axis/Right_Arm/pinky")
onready var f_thumb = get_node("Right_Arm_axis/Right_Arm/thumb")
onready var arm = get_node("Right_Arm_axis/Right_Arm")
onready var axis = get_node("Right_Arm_axis")
onready var hurt_box = get_node("Right_Arm_axis/Right_Arm/right_arm_area/CollisionShape2D2")
onready var t1 = get_node("t1")
onready var t2 = get_node("t2")
var finger_bullet = load("res://EnemeyContainer/bullets/placeholder_bullets.tscn")
var walking = true
var cur_hp = 300
var max_hp = 300
var run_speed = 500
var in_area = false
var timer_active = true
var timer = 9.0
var can_hit = true
var TIMER_TIME = 8
signal found_player
var velocity = Vector2.ZERO
var stop = false
var during_attack = false

func _ready():
#	right_hand_slam(true,3,6)
	pass

func _process(delta):
	$body.global_position = $Right_Arm_axis/Right_Arm/damage_zone/CollisionShape2D.global_position
	$body.rotation = $Right_Arm_axis.rotation
	print("right hand can_hit: %s" % [can_hit])
	if (timer_active&&!stop):
		timer -= delta
		if (timer <= 0):
			print("working_cooose_one+right_ahnd")
			timer_active = false
			if(can_hit):
				choose_one()
			start_timer()
	
#Option: 1,shot 2slam,
func choose_one():
	print(EnemeyStats.skele_left_option)
	if(EnemeyStats.skele_left_down):
		if(EnemeyStats.skele_left_option<2):
			var num = int(rand_range(1,4))
			match num:
				1:
					right_gun_out(3,0.5)
				2:
					right_hand_slam(true,3,5)
				3:
					_rocket_punch(3)
		else:
			var num = int(rand_range(1,3))
			match num:
				1:
					right_gun_out(3,0.5)
				2:
					_rocket_punch(3)
	else:
		pass

func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("player_group")[0]
	if(player&&walking&&!stop):
		if(global_position.x>player.global_position.x):
			run_speed = 650
		else:
			run_speed = 250
		if(in_area):
			ani_player.play("flick")
			walking = false
			yield(ani_player,"animation_finished")
			walking = true
			$Right_Arm_axis/flick_hurtbox/CollisionShape2D.disabled = true
		else:
			ani_player.play("walk")
		velocity = global_position.direction_to(player.global_position)  * run_speed
		velocity = move_and_slide(velocity)

func right_hand_slam(finger,rank,time):
	EnemeyStats.skele_right_option = 2
	during_attack = true
	walking = false
	can_hit = false
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var player= get_tree().get_nodes_in_group("player_group")[0]
#		$Right_Arm_axis.look_at(x.global_position)
#		$Right_Arm_axis.rotation -= PI/2
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
		if(finger):
			while(count>0):
				var y = Timer.new() 
				y.set_wait_time(0.3) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				var b = finger_bullet.instance()
				var m = finger_bullet.instance()
				var i = finger_bullet.instance()
				var c = finger_bullet.instance()
				
				print(b.position)
				print(f_pinky.position)
				owner.add_child(b)
				b.transform = f_pinky.global_transform
				b.global_position = f_pinky.global_position
				
				owner.add_child(m)
				m.transform = f_middle.global_transform
				m.global_position = f_middle.global_position
				
				
				owner.add_child(i)
				i.transform = f_index.global_transform
				i.global_position = f_index.global_position
				
				owner.add_child(c)
				c.transform = f_thumb.global_transform
				c.global_position = f_thumb.global_position
				count -= 1
				if(arm.frame < 15):
					arm.frame += 1
		while(arm.frame != 12):
			var y = Timer.new() 
			y.set_wait_time(0.3) 
			add_child(y)
			y.start()
			yield(y, "timeout")
			if(arm.frame>12):
				arm.frame -= 1
		ani_player.play("hand_slam_final")
		yield(ani_player,"animation_finished")
		
		reset_look()
		ani_player.stop()
	shadow.visible = false
	walking = true
	can_hit = true
	during_attack = false
	EnemeyStats.skele_right_option = 0
func right_gun_out(bullet,shottime):
	EnemeyStats.skele_right_option = 1
	walking = false
	can_hit = false
	arm.frame = 16
	var count = bullet
	ani_player.stop()
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
			var b = finger_bullet.instance()
			owner.add_child(b)
			b.global_transform = f_middle.global_transform
			b.global_position = f_middle.global_position
			b.scale = Vector2(0.8,0.8)
		count -= 1
	arm.frame = 3
	walking = true
	can_hit = true
	EnemeyStats.skele_right_option = 0

func _rocket_punch(startup):
	
	EnemeyStats.skele_left_option = 3
	var temp_vel = Vector2.ZERO
	walking = false
	can_hit = false
	arm.frame = 16
	ani_player.stop()
	$body.disabled = true
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
		$Right_Arm_axis/Right_Arm/fist_area/CollisionShape2D.disabled = false
		while(y.time_left):
			var t = Timer.new() 
			t.one_shot = true
			t.set_wait_time(0.01) 
			add_child(t)
			t.start()
			yield(t,"timeout")
			move_and_slide(temp_vel)
	arm.frame = 3
	walking = true
	can_hit = true
	$body.disabled = false
	during_attack = false
	EnemeyStats.skele_left_option = 0
	$Right_Arm_axis/Right_Arm/fist_area/CollisionShape2D.disabled = true

func onHit(damage) -> void:
	cur_hp -= damage
	$ani_hurt.play("damaged")
	if(cur_hp<=0):
		ani_player.play("dead")
		stop = true
		EnemeyStats.skele_right_down = true

func reset_look():
	shadow.visible = false
	hurt_box.disabled = true
	
func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true
	

func _on_player_detect_area_entered(area):
	if(area.is_in_group("player_group")):
		in_area = true


func _on_player_detect_area_exited(area):
	if(area.is_in_group("player_group")):
		in_area = false
func _stop_everything():
	stop = !stop

func _on_flick_hurtbox_body_entered(body):
	if(body.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)


func _on_damage_zone_area_entered(area):
	if(area.is_in_group("air_group")&&can_hit&&!stop):
		$Right_Arm_axis/Right_Arm/damage_zone/CollisionShape2D.set_deferred("disabled",true)
		$Right_Arm_axis/Right_Arm/damage_zone/CollisionShape2D2.set_deferred("disabled",true)
		yield(right_hand_slam(false,3,5),"completed")
		$Right_Arm_axis/Right_Arm/damage_zone/CollisionShape2D.set_deferred("disabled",false)
		$Right_Arm_axis/Right_Arm/damage_zone/CollisionShape2D2.set_deferred("disabled",false)
		
	if(area.is_in_group("player_group")&&!during_attack):
		$"body".set_deferred("disabled",true)
	if(area.is_in_group("bullet")&&!during_attack):
		$"body".set_deferred("disabled",false)

func _on_damage_zone_area_exited(area):
	if(area.is_in_group("player_group")&&!during_attack):
		$"body".set_deferred("disabled",true)
	if(area.is_in_group("bullet")&&!during_attack):
		$"body".set_deferred("disabled",true)

func _input(event):
	event.is_pressed()


func _on_fist_area_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
