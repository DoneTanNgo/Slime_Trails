extends KinematicBody2D
var bullet_scene = load("res://PlayerHolder/SingleBullet.tscn")
var bubble_scene = load("res://PlayerHolder/BubbleBullet.tscn")
var boomrang_scene = load("res://PlayerHolder/BoomrangBullet.tscn")
var charge_scene = load("res://PlayerHolder/ChargeBullet.tscn")
var muck_scene = load("res://PlayerHolder/muckDirect.tscn")
onready var sound_player = get_node("AudioStreamPlayer")
var player_vol = Vector2(1,1)
var old_position 
var falling = false
var reason = false
var flashlight = false
var platforming = false
var can_shoot = true
var switch = true
var dodging = false
var dodge_timer_active = false
var dodge_out = false
var moving = true
var disabled := false setget set_is_disabled
var alive = true
var charging = false
var weapon_stats
var weapon_stats2
var custom_cooldown = 0.0
var timer = 5
var TIMER_TIME = 0.7
var dodge_timer = 0.0
var aim_direction = Vector2.RIGHT
var speed_bouns = Vector2(0,0)
var player_position = Vector2.RIGHT
var _velocity = Vector2.ZERO
var dodge_charges = 3
var max_dodge_charges = 3
var beg_speed = 0
var ver_speed = 0
var old_direction = 0
var sword_energy = 10
var environmental_spd = Vector2(0,0)
var rs_look = Vector2(0,0)
var deadzone = 0.5
# warning-ignore:unused_signal
signal get_player_position()
# warning-ignore:unused_signal
signal damaged(dmg)
# warning-ignore:unused_signal
signal win()
# warning-ignore:unused_signal
signal rest()

func _ready():
	old_position = global_position
	weapon_stats = Stats.projectile_find(Stats.proj_1)
	weapon_stats2 = Stats.projectile_find(Stats.proj_2)
	Stats.current_Hp = 50
	moving = true
	$CollisionShape2D.disabled = false
	$rotating/Sprite2.hide()
	connect("get_player_position",self,"_player_position")
	connect("damaged",self,"_damaged")
	connect("win",self,"_dance")
	connect("rest",self,"force_resume")
	$AnimationTree.active = true

func _input(event):
	if(Input.is_action_just_pressed("Switch")):
		switch = !switch
	if(Input.get_action_strength("right_click")>0&&!dodging&&dodge_charges>0&&!dodge_out&&alive&&!charging):
		$AnimationTree.set("parameters/Dodging/current",1)
		$Complete_GUI/AnimationPlayer2.play("dodge")
		dodge_charges -= 1
		dodging = true
		start_timer()
	if Input.is_action_just_pressed("Sprint"):
			speed_bouns.x += 300.0
			if(!platforming):
				speed_bouns.y += 300.0
	if Input.is_action_just_released("Sprint"):
		speed_bouns.x -= 300.0
		if(!platforming):
			speed_bouns.y -= 300.0

func _process(delta):
	if(flashlight&&!reason):
		$Light2D.visible = true
		_flashlight_flicker()
	player_vol = global_position - old_position
	old_position = global_position
	if(dodge_out||Input.is_action_just_released("right_click")&&dodging):
		$AnimationTree.active = false
		$AnimationPlayer.play_backwards("Dodge")
		yield($AnimationPlayer,"animation_finished")
		$Complete_GUI/AnimationPlayer2.play_backwards("dodge")
		$AnimationTree.set("parameters/Dodging/current",0)
		$AnimationTree.active = true
		dodging = false
		dodge_out = false

	if(Input.is_joy_known(0)):
		controller_look()
	else:
		$rotating.rotation = get_angle_to(get_global_mouse_position())

	Stats.dodging = dodge_charges
	Stats.swaped = switch
	if(dodge_timer_active):
		dodge_timer -= delta
		if (dodge_timer <= 0):
			if(dodging):
				dodge_timer_active = false
				dodge_charges -= 1
				if(dodge_charges<=0):
					dodge_out = true
					dodge_timer_active = false
					dodge_charges = 0
				else:
					start_timer()
			else:
				dodge_timer_active = false

	if(dodge_charges<max_dodge_charges&&!dodging):
		timer -= delta
		if(timer<=0):
			timer = 3
			dodge_charges += 1
			
	if(Input.get_action_strength("Left_Click") && can_shoot && switch && !dodging&&alive):					#Shotting
		if(has_method(weapon_stats[0])):
			call(weapon_stats[0],(int(weapon_stats[1])),(int(weapon_stats[3])))
			can_shoot = false
			if(custom_cooldown==0):
				var t = Timer.new()
				t.set_wait_time(weapon_stats[2])
				add_child(t)
				t.start()
				yield(t,"timeout")
				t.queue_free()
			else:
				var t = Timer.new()
				t.set_wait_time(custom_cooldown)
				add_child(t)
				t.start()
				yield(t,"timeout")
				t.queue_free()
			if(!charging):
				can_shoot = true

	elif(Input.get_action_strength("Left_Click") && can_shoot && !switch && !dodging&&alive):
		if(has_method(weapon_stats2[0])):
			call(weapon_stats2[0],(int(weapon_stats2[1])),(int(weapon_stats2[3])))
			can_shoot = false
			if(custom_cooldown==0):
				var t = Timer.new()
				t.set_wait_time(weapon_stats2[2])
				add_child(t)
				t.start()
				yield(t,"timeout")
				t.queue_free()
			else:	
				var t = Timer.new()
				t.set_wait_time(custom_cooldown)
				add_child(t)
				t.start()
				yield(t,"timeout")
				t.queue_free()
			can_shoot = true
			
	if(Stats.current_Hp<=0):
		$AnimationTree.active = false
		moving = false
		can_shoot = false
		alive = false
		$AnimationTree.active = false
		$AnimationPlayer.play("Start_death")
		yield($AnimationPlayer,"animation_finished")
		$AnimationPlayer.play("loop_death")
		yield($AnimationPlayer,"animation_finished")
		$"Complete_GUI/Pause/Control/Control2".emit_signal("results",false)

func _physics_process(delta):
	if(moving):
		if(!platforming):
			$Platform.disabled = true
			movement()
			if(falling):
				$AnimationTree.set("parameters/Grounded/current",1)
		else:
			$Platform.disabled = false
			platform_movement()
	player_position = $Area2D/CollisionShape2D2.position
	
func controller_look() -> void:
	rs_look.y = Input.get_joy_axis(0,JOY_AXIS_3)
	rs_look.x = Input.get_joy_axis(0,JOY_AXIS_2)
	if rs_look.length() >= deadzone:
		$rotating.rotation = rs_look.angle()
#	if(Input.get_action_strength("joy_stick_right")):
#		pass
#	var joyx = Input.get_action_strength("joy_stick_right") - Input.get_action_strength("joy_stick_left")
#	var joyy = Input.get_action_strength("joy_stick_down") - Input.get_action_strength("joy_stick_up")
#	$rotating.rotation = Vector2(joyx,joyy).angle()
func movement() -> void:
	var speed = Vector2(600,600)
	var direction = _get_direction()
	_velocity = calculate_velocity(_velocity,direction,speed)		#Momvement Walking and Others
	_velocity += environmental_spd
	_velocity = move_and_slide(_velocity)
	if(direction.y==0&& direction.x==0&&!dodging):
		$AnimationTree.set("parameters/is_moving/current",1)
	else:
		$AnimationTree.set("parameters/is_moving/current",0)
		if(direction.y>1):
			$AnimationTree.set("parameters/direction/current",0)
		else:
			$AnimationTree.set("parameters/direction/current",1)

func platform_movement() -> void:
	var direction = platform_get_direction()
	_velocity = calcuate_move_velocity(_velocity, direction, Vector2(600,400))
	_velocity = move_and_slide(_velocity,Vector2.UP)
			
			
func _get_direction() -> Vector2:
	if(Input.is_joy_known(0)):
		var inputx = Input.get_axis("Left","Right")
		var inputy = Input.get_axis("Up","Down")
		return Vector2(inputx,inputy)
	else:
		return Vector2(
			Input.get_action_strength("Right") - Input.get_action_strength("Left"),
			Input.get_action_strength("Down") - Input.get_action_strength("Up"))

func calculate_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var out:= linear_velocity
	out.x = (speed.x - speed_bouns.x) * direction.x
	out.y = (speed.y - speed_bouns.y) * direction.y
	return out

func platform_get_direction() -> Vector2:
		return Vector2(
			Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		-1.0 if Input.is_action_just_pressed("Up") and is_on_floor() and Input.is_action_just_pressed("Up") else 0.0 
		)
		
func calcuate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var out: = linear_velocity
	if(direction.x!=0&&direction.x==old_direction):
		if(beg_speed<speed.x):
			beg_speed += 20
		else:
			beg_speed = speed.x
			old_direction = direction.x
		out.x = beg_speed * direction.x
	else:
		if(beg_speed>0):
			beg_speed -= 30
		else:
			old_direction = direction.x
			beg_speed = 0
		out.x = beg_speed * old_direction
	
	if(is_on_wall()):
		beg_speed = 0
		old_direction = direction.x
		
	if(!is_on_floor()):
		$AnimationTree.set("parameters/Grounded/current",1)
		ver_speed += 100
		if(ver_speed>700):
			ver_speed = 700
		out.y += ver_speed * get_physics_process_delta_time()
	else:
		$AnimationTree.set("parameters/Grounded/current",0)
		ver_speed = 0

	if direction.y == -1.0:
		out.y = (beg_speed*2/4) * direction.y + speed.y * direction.y
	return out

func pistol_shot(damage,a) -> void:
	custom_cooldown = 0.0
	var b = bullet_scene.instance()
	if(Stats.ammo >= a):
		sound_player.pitch_scale = rand_range(0.8,1.2)
		sound_player.sfx_play("res://Sound/sfx/slime_shot.mp3")
		Stats.ammo -= a
		b.speed = 1000
		b.TIMER_TIME = 2.0
		b.damage = damage
		owner.add_child(b)
		b.transform = $rotating/Position2D.global_transform
	else:
		$Player_effects.play("no_ammo")

func shotgun_shot(damage,a) -> void:
	custom_cooldown = 0.0
	for amount in(1):
		if(Stats.ammo >= a):
			Stats.ammo -= a
			for angle in[-35, -22.5, 0, 22.5, 35]:
				var radians = deg2rad(angle)
				var b = bullet_scene.instance()
				b.TIMER_TIME = 0.5
				b.damage = damage
				b.speed = 1000
				b.transform = $rotating/Position2D.global_transform
				b.rotation = $rotating.rotation + radians
				owner.add_child(b)
		else:
			$Player_effects.play("no_ammo")
				
				
func bubble_shot(damage,a) -> void:
	custom_cooldown = 0.0
	if(Stats.ammo>=a):
		Stats.ammo -= a
		var x = 6
		while(x>0):
			var radian = deg2rad(rand_range(-35,35))
			var b = bubble_scene.instance()
			b.speed = rand_range(400,800)
			b.TIMER_TIME = 5.0
			b.damage = damage
			b.transform = $rotating/Position2D.global_transform
			b.rotation = $rotating.rotation + radian
			owner.add_child(b)
			x-=1
	else:
		$Player_effects.play("no_ammo")

func melee_shot(damage: float,a) -> void:
	$AnimationPlayer.play("melee_attack")
	yield($AnimationPlayer,"animation_finished")
	if(Input.get_action_strength("Left_Click")):
		custom_cooldown = 0.9
		$AnimationPlayer.play("melee_2nd_attack")
	else:
		custom_cooldown = 0.0

func boomrang_shot(damage: float, a) -> void:
	var b = boomrang_scene.instance()
	if(Stats.ammo >= a):
		Stats.ammo -= a
		b.speed = 1000
		b.TIMER_TIME = 4.0
		b.damage = damage
		owner.add_child(b)
		b.transform = $rotating/Position2D.global_transform

func muck_shot(damage: float, a) -> void:
	var b = muck_scene.instance()
	if(Stats.ammo >= a):
		Stats.ammo -= a
		b.speed = 500
		b.TIMER_TIME = 8.0
		b.damage = damage
		owner.add_child(b)
		b.transform = $rotating/Position2D.global_transform

func charge_shot(damage: float, a) -> void:
	if(Input.get_action_strength("Left_Click")&&Stats.ammo >= a):
		var b = charge_scene.instance()
		var ani = "0_charging"
		speed_bouns.x = speed_bouns.x + 150
		speed_bouns.y = speed_bouns.y + 150
		b.damage = damage
		charging = true
		b.rank = 0
		$Player_effects.play(ani)
		_charge_timer(1)
		while(Input.get_action_strength("Left_Click")&&charging):
			var y = Timer.new() 
			y.set_wait_time(0.01) 
			add_child(y)
			y.start()
			yield(y, "timeout")
			y.queue_free()
			if(b.rank >=2):
				b.rank = 2
				if($Charge.time_left<0.2):
					_charge_timer(2)
					Stats.ammo -= 2
			else:
				if($Charge.time_left<0.2):
					b.rank += 1
					ani = "%d_charging" % [b.rank]
					$Player_effects.play(ani)
					_charge_timer(2)
			if(Input.get_action_strength("Left_Click")==0):
				can_shoot = true
				Stats.ammo -= a
				owner.add_child(b)
				$Charge.stop()
				$Player_effects.play("charge_die")
				b.transform = $rotating/Position2D.global_transform
				speed_bouns.x -= 150
				speed_bouns.y -= 150
				charging = false

func start_timer() -> void:
	dodge_timer = TIMER_TIME
	dodge_timer_active = true
	
	
func _player_position() -> Vector2:
	return $Icon.global_position

func _damaged(dmg: float) -> void:
	if($Area2D/CollisionShape2D2.disabled==false&&!disabled):
		Stats._dectect_damage(dmg)
		$Complete_GUI/AnimationPlayer.play("damaged")
		$AnimationTree.set("parameters/damaged/current",1)
		var y = Timer.new() 
		y.set_wait_time(1.3) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		y.queue_free()
		$AnimationTree.set("parameters/damaged/current",0)

func _dance()-> void:
	$Camera2D.current = true
	$AnimationTree.active = false
	$AnimationPlayer.play("winmation")
	yield($AnimationPlayer,"animation_finished")
	$Complete_GUI/Pause/Control/Control2.emit_signal("results",true)

func _on_Area2D_area_entered(area) -> void:
	if(area.is_in_group("enemey_group")):
		$Complete_GUI/AnimationPlayer.play("damaged")
		$AnimationTree.set("parameters/damaged/current",1)
		var t = Timer.new()
		t.set_wait_time(1.3)
		add_child(t)
		t.start()
		yield(t,"timeout")
		t.queue_free()
		$AnimationTree.set("parameters/damaged/current",0)

func _flashlight_flicker()->void:
	var x = int(rand_range(0,2))
	flashlight = false
	print(x)
	if(x==0):
		$Light2D.energy = 0.3
		var y = Timer.new() 
		y.set_wait_time(1) 
		add_child(y)
		y.start()
		yield(y, "timeout")
		y.queue_free()
		$Light2D.energy = 0.7
	var y = Timer.new() 
	y.set_wait_time(3) 
	add_child(y)
	y.start()
	yield(y, "timeout")
	y.queue_free()
	flashlight = true

func _charge_timer(time) -> void:
	if(time==609):
		$Charge.stop()
	else:
		$Charge.start(time)

func set_is_disabled(cast: bool) -> void:
	can_shoot = !cast
	moving = !cast
	$Area2D/CollisionShape2D2.disabled = cast
	$CollisionShape2D.disabled = cast
	

func _on_Sword_body_entered(body):
	if(body.is_in_group("boss_group")):
		body.onHit(6)

func _on_Sword_area_entered(area):
	if(area.is_in_group("proj")):
		area.queue_free()
