extends KinematicBody2D
var bullet_scene = load("res://EnemeyContainer/bullets/mage_bullets.tscn")
var spiral_scene = load("res://EnemeyContainer/bullets/mage_bullets_spiral.tscn")
onready var sfx = get_node("AudioStreamPlayer2D")
var cur_hp = 550
var max_hp = 550
var easy_mode = false
var timer = 0.0
var timer_active = false
var rng
var allow_timer = true
var can_shoot = true
const TIMER_TIME = 5
var hp = 100

func _ready():
	EnemeyStats.current_Hp = 650
	EnemeyStats.max_Hp = 650
	start_timer()
	pass

func _process(delta):
	if (timer_active && allow_timer):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			if(can_shoot):
				$AnimationTree.set("parameters/Action/current",0)
				choose_one()
			start_timer()
			
func choose_one() -> void:
	rng = RandomNumberGenerator.new()
	var num = int(rand_range(0,7))
	can_shoot = false
	if(cur_hp>=max_hp/2 || easy_mode):
		match num:
			0:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				third_shot(3)
			1:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				throwup_shot(4)
			2:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				spiral_shot(10)
			3:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				wiggles_shot(10)
			4:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				circle_shot(3)
			5:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				straight_triple_shot(3)
			6:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				beam_shot(3)
	else:
		match num:
			0:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				circle_shot(5)
				wiggles_shot(5)
			1:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				throwup_shot(5)
				circle_shot(5)
			2:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				wiggles_shot(5)
				spiral_shot(5)
			3:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				circle_shot(5)
				wiggles_shot(5)
			4:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				beam_shot(3)
				throwup_shot(3)
			5:
				$AnimationTree.set("parameters/Transition/current",1)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				circle_shot(5)
				y.set_wait_time(0.5) 
				y.start()
				yield(y, "timeout")
				circle_shot2(5)
			6:
				$AnimationTree.set("parameters/Transition/current",0)
				var y = Timer.new() 
				y.set_wait_time(1) 
				add_child(y)
				y.start()
				yield(y, "timeout")
				beam_shot(3)
	$AnimationTree.set("parameters/Action/current",1)


func throwup_shot(time) -> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_01_01.mp3")
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):
		var y = Timer.new() 
		y.set_wait_time(0.5) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		for angle in[rand_range(-35.0,-30.0),rand_range(-30.0,-20.0), rand_range(-20.5,-10.5), rand_range(-5.0,-0.0), 0,rand_range(35.0,30.0),rand_range(30.0,20.0), rand_range(20,0), rand_range(10.0,0.0)]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			owner.add_child(b)
			b.transform = $Position2D.global_transform
			var p = get_tree().get_nodes_in_group("player_group")[0]
			$Position2D.look_at(Vector2(p.position))
			b.rotation = $Position2D.rotation + radians
	t.queue_free()
	can_shoot = true
			
func third_shot(time) -> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_01_02.mp3")
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):
		var y = Timer.new() 
		y.set_wait_time(0.5) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		for angle in[-35, -30, -22.5,-15, -10, 0, 10, 15, 22.5, 30, 35]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			owner.add_child(b)
			b.transform = $Position2D.global_transform
			var p = get_tree().get_nodes_in_group("player_group")[0]
			$Position2D.look_at(Vector2(p.position))
			b.rotation = $Position2D.rotation + radians
	t.queue_free()
	can_shoot = true

func spiral_shot(time) -> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_01_03.mp3")
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):
		var y = Timer.new() 
		y.set_wait_time(0.05) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		$Position2D.rotate(2) #Change Pattern of Projectil
		var b = spiral_scene.instance()
		owner.add_child(b)
		b.transform = $Position2D.global_transform
		b.rotation = $Position2D.rotation
	can_shoot = true
	pass

func wiggles_shot(time) -> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_01_02.mp3")
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	var rot = int(rand_range(1,5))
	while(int(t.time_left)>0&&cur_hp>0):
#		if(GlobalScript._yield_time(0.03)):
		var y = Timer.new() 
		y.set_wait_time(0.03) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		$Position2D.rotate(rot) #Change Pattern of Projectil
		var b = bullet_scene.instance()
		owner.add_child(b)
		b.transform = $Position2D.global_transform
		b.rotation = $Position2D.rotation
	t.queue_free()
	can_shoot = true

func spiral_shot2(time) -> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_01_03.mp3")
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	var rot = int(rand_range(1,5))
	while(int(t.time_left)>0&&cur_hp>0):
		var y = Timer.new() 
		y.set_wait_time(0.03) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		$Position2D.rotate(rot) #Change Pattern of Projectil
		var b = spiral_scene.instance()
		owner.add_child(b)
		b.transform = $Position2D.global_transform
		b.rotation = $Position2D.rotation
	t.queue_free()
	can_shoot = true

func circle_shot(time) -> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_04_01.mp3")
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):
		var y = Timer.new() 
		y.set_wait_time(0.9) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		for angle in[-180,-160,-140,-120,-100,-80,-60, -40, -20, 0, 20, 40, 60, 80, 100, 120, 140, 160, 180]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			b.speed = 650
			b.transform = $Position2D.global_transform
			b.rotation = $Position2D.rotation + radians
			owner.add_child(b)
	t.queue_free()
	can_shoot = true

func circle_shot2(time)-> void:
	sfx.sfx_play("res://Sound/sfx/_mage_atk_04_01.mp3")
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):
		var y = Timer.new() 
		y.set_wait_time(0.9) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		for angle in[-170,-150,-130,-110,-90,-70,-50, -30, -10, 10, 30, 50, 70, 90, 110, 130, 150, 170]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			b.speed = 650
			b.transform = $Position2D.global_transform
			b.rotation = $Position2D.rotation + radians
			owner.add_child(b)
	t.queue_free()
	can_shoot = true

func straight_triple_shot(time):
	sfx.sfx_play("res://Sound/sfx/_mage_atk_01_02.mp3")
	can_shoot = false
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	var p = get_tree().get_nodes_in_group("player_group")[0]
	$Position2D.look_at(Vector2(p.position))
	while(int(t.time_left)>0&&cur_hp>0):	
		var y = Timer.new() 
		y.set_wait_time(0.1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		for angle in[-30, -10, 0, 10, 30]:
			var radians = deg2rad(angle)
			var b = bullet_scene.instance()
			owner.add_child(b)
			b.transform = $Position2D.global_transform
			b.rotation = $Position2D.rotation + radians
	t.queue_free()
	can_shoot = true

func beam_shot(time):
	sfx.sfx_play("res://Sound/sfx/_mage_atk_04_01.mp3")
	var t = Timer.new() 		
	t.set_wait_time(time) 		
	add_child(t)			
	t.start()
	while(int(t.time_left)>0&&cur_hp>0):	
		var y = Timer.new() 
		y.set_wait_time(0.01) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		var b = bullet_scene.instance()
		b.speed = 1200
		owner.add_child(b)
		b.transform = $Position2D.global_transform
		var p = get_tree().get_nodes_in_group("player_group")[0]
		$Position2D.look_at(Vector2(p.position))
	can_shoot = true

func onHit(damage) -> void:
	cur_hp -= damage
	EnemeyStats.current_Hp = cur_hp
	EnemeyStats.max_Hp = max_hp
	$AnimationPlayer.play("damaged")
	if(cur_hp<=0):
		$AnimationTree.active = false
		allow_timer = false
		_process(false)
		$Camera2D.current = true
		var a = owner.get_children()
		for x in a:
			if(x.is_in_group("enemey_group")):
				x.queue_free()
		$AnimationPlayer.play("camerazoom")
		yield($AnimationPlayer,"animation_finished")
		
		var y = Timer.new() 
		y.set_wait_time(0.1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		
		$AnimationPlayer.play("death")
		
func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _input(event):
	if(event.is_action_pressed("space_bar")):
		beam_shot(3)

