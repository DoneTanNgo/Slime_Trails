extends KinematicBody2D
var running_thoughts = load("res://EnemeyContainer/Skele_type/running_thoughts.tscn")
var bloody_eyes = load("res://EnemeyContainer/Skele_type/blood_eyes.tscn")
var finger_bullet = load("res://EnemeyContainer/bullets/placeholder_bullets.tscn")
onready var general_timer = get_node("gen_timer")
onready var ani_spawn_timer = get_node("ani_spawn/ani_spawn_timer")
onready var spawn_animation = get_node("ani_spawn")
onready var head_animation = get_node("ani_head")
var cur_hp = 650.0
var max_hp = 650.0
var timer = 3.0
const TIMER_TIME = 10
var rng
var walking = true
var ani_spawn = true
var timer_active = true
var allow_timer = true
var can_hit = true
var switch = true
var animation_timer = false
var stop = false
var velocity = Vector2.ZERO
var run_speed = 500
var direction = Vector2.ZERO

func _input(event):
	$moving.play("movement")
	if(event.is_action_pressed("space_bar")):
		_teeth_shoots(300)

func _ready():
	direction = 1

func _process(delta):
	if (timer_active && allow_timer&&!stop):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			if(can_hit):
				choose_one()
			start_timer()
func _physics_process(delta):
	if(walking):
		velocity.x = run_speed * direction
		move_and_slide(velocity)
	if(is_on_wall()):
		direction = direction * -1

func choose_one():
	var num = int(rand_range(0,3))
	if(EnemeyStats.skele_left_down&&EnemeyStats.skele_right_down):
		match num:
				0:
					yield(_beam_down(0.5),"completed")
				1:
					yield(_teeth_shoots(550),"completed")
				2:
					yield(_backward_teeth_shoots(550),"completed")
		num = int(rand_range(0,9))
		if(num<2):
			yield(_running_thoughts(1500),"completed")
		num = int(rand_range(0,9))
		if(num<2&&get_tree().get_nodes_in_group("eye_group").count(bloody_eyes)<=1):
			yield(_blood_eyes(0.5),"completed")
	elif(EnemeyStats.skele_left_down||EnemeyStats.skele_right_down):
		match num:
				0:
					yield(_beam_down(1),"completed")
				1:
					yield(_teeth_shoots(400),"completed")
				2:
					yield(_backward_teeth_shoots(400),"completed")
		num = int(rand_range(0,9))
		if(num<2&&get_tree().get_nodes_in_group("eye_group").count(bloody_eyes)<=1):
			yield(_running_thoughts(1300),"completed")
		num = int(rand_range(0,9))
		if(num<2&&get_tree().get_nodes_in_group("eye_group").count(bloody_eyes)<=1):
			yield(_blood_eyes(0.7),"completed")
	else:
		match num:
				0:
					yield(_beam_down(1),"completed")
				1:
					yield(_teeth_shoots(300),"completed")
				2:
					yield(_backward_teeth_shoots(300),"completed")
		num = int(rand_range(0,9))
		if(num<2&&get_tree().get_nodes_in_group("eye_group").count(bloody_eyes)<=1):
			yield(_running_thoughts(1000),"completed")
		num = int(rand_range(0,9))
		if(num<2&&get_tree().get_nodes_in_group("eye_group").count(bloody_eyes)<=1):
			yield(_blood_eyes(1.0),"completed")
		
				
func _running_thoughts(speed):
	can_hit = false
	var c = running_thoughts.instance()
	if(rand_range(-1,1)>0):
		head_animation.play("right_head_thoughts_spawn")
		var y = Timer.new() 
		y.set_wait_time(1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		spawn_animation.play("thoughts_right")
		add_child(c)
		c.run_speed = speed
		c.global_position = $thoughts2.global_position
		c.global_scale = Vector2(3.5,3.5)
		$ani_spawn/ani_spawn_timer.start(0.9)
		ani_spawn = true
		while(ani_spawn): 
			y.set_wait_time(0.01) 
			y.start()
			yield(y, "timeout")
			c.global_position = $thoughts2.global_position
	else:
		head_animation.play("left_head_thoughts_spawn")
		var y = Timer.new() 
		y.set_wait_time(1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		spawn_animation.play("thoughts_left")
		add_child(c)
		c.global_position = $thoughts.global_position
		c.global_scale = Vector2(3.5,3.5)
		$ani_spawn/ani_spawn_timer.start(0.9)
		ani_spawn = true
		while(ani_spawn):
			y.set_wait_time(0.01) 
			y.start()
			yield(y, "timeout")
			c.global_position = $thoughts.global_position
	can_hit = true

func _blood_eyes(cooldown):
	can_hit = false
	var c = bloody_eyes.instance()
	if(rand_range(-1,1)>0):
		$eye.position = Vector2(-50.126,-180.125)
		head_animation.play("left_eye_popped")
		var y = Timer.new() 
		y.set_wait_time(0.4) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		add_child(c)
		c.cooldown = cooldown
		c.global_position = $eye.global_position
		c.global_scale = Vector2(1,1)
	else:
		$eye.position = Vector2(57.126,-180.125)
		head_animation.play("right_eye_popped")
		var y = Timer.new() 
		y.set_wait_time(0.4) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		add_child(c)
		c.global_position = $eye.global_position
		c.global_scale = Vector2(1,1)
	can_hit = true

func _teeth_shoots(speed):
	can_hit = false
	var y = Timer.new()
	y.one_shot = true
	y.set_wait_time(0.8)
	add_child(y)
	y.start()
	head_animation.play("open_mouth_teeth")
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var player = get_tree().get_nodes_in_group("player_group")[0]
		while(y.time_left):
			var t = Timer.new()
			t.set_wait_time(0.1)
			add_child(t)
			t.one_shot = true
			t.start()
			yield(t,"timeout")
			print(y.time_left)
			var dist = global_position.distance_to(player.global_position)
			var direction = global_position.direction_to(player.global_position + player.player_vol * (dist/30))
			$Head/tooth_spawn.look_at(player.global_position + player.player_vol * (dist/20))
			var b = finger_bullet.instance()
			owner.add_child(b)
			b.global_transform = $Head/tooth_spawn.global_transform
			b.speed = speed
	can_hit = true
	$Head.frame = 0

func _backward_teeth_shoots(speed):
	can_hit = false
	var y = Timer.new()
	y.one_shot = true
	y.set_wait_time(0.8)
	add_child(y)
	y.start()
	head_animation.play_backwards("open_mouth_teeth")
	if(!get_tree().get_nodes_in_group("player_group").empty()):
		var player = get_tree().get_nodes_in_group("player_group")[0]
		while(y.time_left):
			var t = Timer.new()
			t.set_wait_time(0.1)
			add_child(t)
			t.one_shot = true
			t.start()
			yield(t,"timeout")
			print(y.time_left)
			var dist = global_position.distance_to(player.global_position)
			var direction = global_position.direction_to(player.global_position + player.player_vol * (dist/30))
			$Head/tooth_spawn.look_at(player.global_position + player.player_vol * (dist/20))
			var b = finger_bullet.instance()
			owner.add_child(b)
			b.global_transform = $Head/tooth_spawn.global_transform
			b.speed = speed
	can_hit = true
	$Head.frame = 0

func _beam_down(time):
	can_hit = false
	head_animation.play("laser_beam")
	yield(head_animation,"animation_finished")
	var y = Timer.new()
	y.set_wait_time(time)
	add_child(y)
	y.one_shot = true
	y.start()
	yield(y,"timeout")
	$Head/axis/laser.firing_my_laser()
	y.set_wait_time(4.0)
	y.start()
	yield(y,"timeout")
	$Head/axis/laser.firing_my_laser()
	can_hit = true
	$Head.frame = 0
	
func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		stop = true
		walking = false
	
func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_ani_spawn_timer_timeout():
	ani_spawn = false
	$ani_spawn/ani_spawn_timer.stop()

func _on_gen_timer_timeout():
	animation_timer = false
	$gen_timer.stop()

