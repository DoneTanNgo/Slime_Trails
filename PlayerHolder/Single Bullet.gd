extends Node2D
var timer = 0.0
var timer_active = false
var TIMER_TIME = 0.5
var speed = 1000
var damage = 1


func _ready():
	$Area2D/CollisionShape2D.disabled = false
	start_timer()
	
func _process(delta):
	position += transform.x * speed * delta
	if (timer_active):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			queue_free()

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_Area2D_body_entered(body):
	if(body.is_in_group("boss_group")||body.is_in_group("small_group")):
		if(body):
			body.onHit(damage)
			$AnimationPlayer.play("burst")
			yield($AnimationPlayer,"animation_finished")
		speed = 0
		queue_free()


func _on_Area2D_area_entered(area):
	if(area.is_in_group("Shield")):
		$AnimationPlayer.play("burst")
		yield($AnimationPlayer,"animation_finished")
	if(area.is_in_group("wall_group")):
		speed = 0
		$AnimationPlayer.play("burst")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
