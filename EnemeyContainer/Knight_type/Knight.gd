extends KinematicBody2D
var bullet_scene = load("res://EnemeyContainer/bullets/beam_slash.tscn")
var small_guy_scene = load("res://EnemeyContainer/Basic_enemies/small_knight.tscn")
var charge_guy_scene = load("res://EnemeyContainer/Basic_enemies/charge_knight.tscn")
signal dying(x)
var cur_hp = 650
var max_hp = 650
var run_speed = 350
var charge_speed = 1250
var timer = 0.0
const TIMER_TIME = 3
var rng
var easy_mode = false
var timer_active = false
var allow_timer = true
var can_hit = true
var can_move = true
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var temp_position
var charging
var player
var near
var shielded = false


#if is_on_wall():
#		_velocity.x *= -1.0
func _ready():
	EnemeyStats.current_Hp = 650
	EnemeyStats.max_Hp = 650
	start_timer()
	$Sword.set("parameters/Active/current",1)
	$Shield2.set("parameters/Alive/current",1)
	$Shield2.set("parameters/Down/current",0)
	$Movment.set("parameters/Died/current",0)
	pass

func _process(delta):
	player = get_tree().get_nodes_in_group("player_group")[0]
	if(player&&can_move&&!charging):
		velocity = position.direction_to(player.position) * run_speed
		velocity = move_and_slide(velocity)
	elif(charging):
		velocity = direction * charge_speed
		#velocity.y = position.direction_to(temp_position) * charge_speed
		velocity = move_and_slide(velocity)
		
	if (timer_active && allow_timer):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			if(can_hit):
				choose_one()
			start_timer()
	
	pass
	
func choose_one() -> void:
	rng = RandomNumberGenerator.new()
	var num = int(rand_range(0,4))
#	$AnimationPlayer.play("Count down")
#	yield($AnimationPlayer,"animation_finished")
	if(cur_hp>=max_hp/2 || easy_mode):
		if(near):
			var x = int(rand_range(0,3))
			if(x==0):
				slash()
			elif(x==1):
				double_slash()
			else:
				multi_thrust()
		else:
			var x = int(rand_range(0,2))
			if(x==0):
				beam_slash()
			else:
				charge()

	else:
		if(near):
			var x = int(rand_range(0,3))
			if(x==0):
				slash()
			elif(x==1):
				double_slash()
			else:
				multi_thrust()
		else:
			var x = int(rand_range(0,2))
			if(x==0):
				beam_slash()
			else:
				charge()
				
		if(!shielded):
			var y = int(rand_range(0,3))
			shield_up(y)
		
		
		
		if(get_tree().get_nodes_in_group("small_group").empty()):
			summon_knights()
			var y = Timer.new()
			y.set_wait_time(1.5)
			add_child(y)
			y.start()
			yield(y,"timeout")
			summon_knights()

func slash() -> void:
	can_move = false
	can_hit = false
	
	$Movment.set("parameters/Died/current",1)
	$Movment.set("parameters/Attacking/current",0)
	var y = Timer.new()
	y.set_wait_time(0.7)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$Position2D.look_at(Vector2(player.position))
	$Sword.set("parameters/Active/current",2)
	$Sword.set("parameters/Attacks/current",0)
	y.set_wait_time(1.7)
	y.start()
	yield(y,"timeout")
	$Sword.set("parameters/Active/current",1)
	$Movment.set("parameters/Died/current",0)
	$Position2D.rotation = 0
	can_hit = true
	can_move = true
	
func double_slash() -> void:
	can_move = false
	can_hit = false
	$Movment.set("parameters/Died/current",1)
	$Movment.set("parameters/Attacking/current",0)
	var y = Timer.new()
	y.set_wait_time(0.7)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$Position2D.look_at(Vector2(player.position))
	can_move = true
	$Sword.set("parameters/Active/current",2)
	$Sword.set("parameters/Attacks/current",3)
	y.set_wait_time(2.7)
	y.start()
	yield(y,"timeout")
	$Sword.set("parameters/Active/current",1)
	$Movment.set("parameters/Died/current",0)
	$Position2D.rotation = 0
	can_hit = true
	
func beam_slash() -> void:
	can_hit = false
	can_move = false
	$Sword.set("parameters/Active/current",3)
	var y = Timer.new()
	y.set_wait_time(0.8)
	add_child(y)
	y.start()
	yield(y,"timeout")
	can_move = true
	$Position2D.look_at(Vector2(player.position))
	$Sword.set("parameters/Active/current",2)
	$Sword.set("parameters/Attacks/current",1)
	var b = bullet_scene.instance()
	b.speed = 800
	owner.add_child(b)
	b.transform = $Position2D.global_transform
	var p = get_tree().get_nodes_in_group("player_group")[0]
	$Position2D.look_at(Vector2(p.position))
	y.set_wait_time(1.7)
	y.start()
	yield(y,"timeout")
	$Sword.set("parameters/Active/current",1)
	$Position2D.rotation = 0
	can_hit = true

func multi_thrust() -> void:
	can_hit = false
	$Movment.set("parameters/Died/current",1)
	$Movment.set("parameters/Attacking/current",0)
	var y = Timer.new()
	y.set_wait_time(0.7)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$Position2D.rotation = get_angle_to(player.position)
	$Position2D.look_at(Vector2(player.position))
	$Sword.set("parameters/Active/current",2)
	$Sword.set("parameters/Attacks/current",2)
	y.set_wait_time(2.5)
	y.start()
	yield(y,"timeout")
	$Sword.set("parameters/Active/current",1)
	$Position2D.rotation = 0
	$Movment.set("parameters/Died/current",0)
	can_hit = true

func charge() -> void:
	$Movment.set("parameters/Died/current",1)
	$Movment.set("parameters/Attacking/current",1)
	can_move = false
	var y = Timer.new()
	y.set_wait_time(0.75)
	add_child(y)
	y.start()
	yield(y,"timeout")
	can_move = true
	$Position2D.rotation = get_angle_to(player.position)
	temp_position = player.position
	direction = position.direction_to(temp_position)
	charging = true
	$Position2D.look_at(Vector2(player.position))
	$Sword.set("parameters/Active/current",2)
	$Sword.set("parameters/Attacks/current",2)
	y.set_wait_time(1.5)
	y.start()
	yield(y,"timeout")
	$Sword.set("parameters/Active/current",1)
	$Position2D.rotation = 0
	$Movment.set("parameters/Died/current",0)
	charging = false

func shield_up(x)-> void:
	can_move = true
	can_hit = false
	shielded = true
	$Shield2.set("parameters/Alive/current",0)
	$Shield2.set("parameters/UP/current",x)
	var y = Timer.new()
	y.set_wait_time(3)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$Shield2.set("paramaters/Alive/current",1)
	$Shield.set("parameters/Down/current",x)
	shielded = false
	can_hit = true
	can_move = true

func summon_knights() -> void:
	var c = charge_guy_scene.instance()
	owner.add_child(c)
	c.global_transform = $spawn.global_transform
	pass

func onHit(damage) -> void:
	cur_hp -= damage
	EnemeyStats.current_Hp = cur_hp
	EnemeyStats.max_Hp = max_hp
	if(cur_hp<=0):
		allow_timer = false
		set_process(false)
		set_physics_process(false)
		$Sword.active = false
		$Shield2.active = false
		$Movment.active = false
		$Camera2D.current = true
		$AnimationPlayer.play("camerazoom")
		yield($AnimationPlayer,"animation_finished")
		var y = Timer.new()
		y.set_wait_time(1)
		add_child(y)
		y.start()
		yield(y,"timeout")
		var a = owner.get_children()
		for x in a:
			if(x.is_in_group("enemey_group")||x.is_in_group("small_group")):
				x.queue_free()
		$AnimationPlayer.play("death")
	pass

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true
	
func _input(event):
	if(Input.is_action_just_pressed("space_bar")):
		pass
	pass



func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",10)


func _on_Detect_person_position_body_entered(body):
	if(body.is_in_group("player_group")):
		near = body


func _on_Detect_person_position_body_exited(body):
	if(body.is_in_group("player_group")):
		near = null
