extends Node2D
var timer = 0.0
var timer_active = false
var TIMER_TIME = 0.5
var speed = 1000
var damage = 1


func _ready():
	$Area2D/CollisionShape2D.disabled = false
	$AnimationPlayer.play("spin")
	start_timer()
	
func _process(delta):
	position += transform.x * speed * delta
	if (timer_active):
		timer -= delta
		if(speed > 200):
			speed -= 15
		else:
			speed -= 45
		if (timer <= 0):
			timer_active = false
			bursting()

func bursting() ->void:
	
	$AnimationPlayer.play("burst")
	yield($AnimationPlayer,"animation_finished")
	queue_free()

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true


func _on_Area2D_body_entered(body):
	if(body.is_in_group("boss_group")||body.is_in_group("small_group")):
		if(speed>0):
			if(body):
				body.onHit(damage)
				bursting()
			speed = 0
		else:
			if(body):
				body.onHit(damage*5)
				bursting()
			speed = 0


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

