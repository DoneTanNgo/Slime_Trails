extends Node2D
var timer = 0.0
var timer_active = false
var TIMER_TIME = 0.5
var speed = 1000
var damage = 2
var rank = 0
var decay_time = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	match rank:
			0:
				speed = 700
				$AnimationPlayer.play("small_fire")
			1:
				damage = damage * 3
				speed = 1000
				$AnimationPlayer.play("med_fire")
				
			2:
				damage = damage * 6.5
				speed = 1800
				$AnimationPlayer.play("final_fire")
	
func _process(delta):
	position += transform.x * speed * delta
	if (timer_active):
		timer -= delta
		
		if (timer <= 0):
			timer_active = false
			queue_free()

func bursting() ->void:
	queue_free()

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true


func _on_Area2D_body_entered(body):
	if(body.is_in_group("boss_group")||body.is_in_group("small_group")):
		if(body):
			body.onHit(damage)
			print(damage)
			queue_free()


func _on_Area2D_area_entered(area):
	if(area.is_in_group("Shield")):
		speed = 0
		queue_free()
	if(area.is_in_group("wall_group")):
		bursting()
		speed = 0
		queue_free()
	pass

