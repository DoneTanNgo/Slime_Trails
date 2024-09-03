extends Node2D
var timer = 10.0
var timer_active = false
var TIMER_TIME = 0.5
var speed = 1000
var damage = 2
var charge = false
func _ready():
	$AnimationPlayer.play("charging")
	start_timer()
	
func _process(delta):
	position += transform.x * speed * delta
	if (timer_active&&!charge):
		
		timer -= delta
		if(speed > 300):
			speed -= 50
		elif(speed> 50):
			speed -= 5
		else:
			speed = 0
		if(speed<=0):
			charging()
		if (timer <= 0):
			timer_active = false
			bursting()
	elif(timer_active&&charge):
		timer -= delta
		
		if (timer <= 0):
			timer_active = false
			bursting()
			
func bursting() ->void:
	
	$AnimationPlayer.play("bursting")
	yield($AnimationPlayer,"animation_finished")
	queue_free()

func charging() -> void:
	print(rotation)
	rotation = 0
	charge = !charge
	var t = Timer.new() 
	t.one_shot = true
	t.set_wait_time(0.5) 
	add_child(t)
	t.start()
	yield(t,"timeout")
	if(!get_tree().get_nodes_in_group("boss_group").empty()):
		var x = get_tree().get_nodes_in_group("boss_group")[0]
		var temp_angle = get_angle_to(x.position)
		rotation = temp_angle
		print(x.position)
	$AnimationPlayer.play("firing")
	speed = 2000

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_Area2D_body_entered(body):
	if(body.is_in_group("boss_group")||body.is_in_group("small_group")):
		if(body):
			body.onHit(damage)
			bursting()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Shield")):
		speed = 0
		queue_free()
	if(area.is_in_group("wall_group")):
		bursting()
		speed = 0
		queue_free()
	if(area.is_in_group("damage_zone")):
		bursting()
		speed = 0 
		queue_free()
		pass
	pass
