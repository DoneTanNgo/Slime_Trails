extends KinematicBody2D
var max_hp = 8
var cur_hp = 8
var run_speed = 800
var velocity = Vector2.ZERO
var direction = Vector2(1,1)
var player = null
var time = 0.0
var died = false
var out = false
var aim = Vector2.ZERO
var moving = true
var cooldown = 1.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$lazer_axis/Line2D.visible = false
	var x = get_tree().get_nodes_in_group("player_group")[0]
	$CollisionShape2D.disabled = true
	var y = Timer.new() 
	y.set_wait_time(1) 
	add_child(y)
	y.start()
	yield(y, "timeout")
	$CollisionShape2D.disabled = false
	$laser_timer.start(2)
	$ani_bot.play("normal")

func _physics_process(delta):
	if(!died&&moving):
		run_speed = 500
		velocity = Vector2.ZERO
		var x = 1
		if(rand_range(-1,1)>0):
			x = 1
		else:
			x = -1
		if(is_on_wall()):
			direction.y = -(direction.y)
			direction.x = -x*(direction.x)
		velocity = direction * run_speed
		velocity = move_and_slide(velocity)
	else:
		velocity = move_and_slide(Vector2(0,0))

func _laser():
	out = !out
	var x = get_tree().get_nodes_in_group("player_group")[0]
	$ani_top.play("charge_up")
	yield($ani_top,"animation_finished")
	$lazer_axis/Line2D.visible = true
#	moving = !moving
	$lazer_axis.look_at(x.position)
	$lazer_axis.rotation -= PI/2
	$ani_top.play("laser_out")
	yield($ani_top,"animation_finished")
	$lazer_axis/lazer.firing_my_laser()
	$lazer_axis/Line2D.visible = false
	var t = Timer.new() 
	t.one_shot = true
	t.set_wait_time(cooldown) 
	add_child(t)
	t.start()
#	_hot_fix(temp_pos)
	yield(t,"timeout")
	$lazer_axis/lazer.firing_my_laser()
	$ani_top.play("retract")
	
	yield($ani_top,"animation_finished")
	out = !out
	moving = !moving

func _hot_fix(temp_pos):
	var t = Timer.new() 
	t.one_shot = true
	t.set_wait_time(cooldown) 
	add_child(t)
	t.start()
	yield(t,"timeout")
	while(t.time_left):
		var y = Timer.new() 
		y.one_shot = true
		y.set_wait_time(0.01) 
		add_child(y)
		y.start()
		yield(t,"timeout")
		global_position = temp_pos

func _on_laser_timer_timeout():
	if(!out):
#		pass
		_laser()
		
func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		died = true
		queue_free()
#func _find_closest_player():
#
#
#	for x in p:
#		if(x.position>closest.position):
#			closest = x
#			print(closest)



