extends Node2D
var timer = 0.0
var timer_active = false
const TIMER_TIME = 5
var speed = 800
var frames = 0

func _ready():
	$CollisionShape2D.disabled = false
	start_timer()
	
	
func _process(delta):
	position += transform.x * speed * delta
	if (timer_active):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			queue_free()

func bursting() -> void:
	speed = 0
	$AnimationPlayer.play("burst")
	yield($AnimationPlayer,"animation_finished")
	queue_free()

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_Area2D_area_entered(area):
	if(area.is_in_group("instant_delete")):
		queue_free()
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",10)
		bursting()
	if(area.is_in_group("wall_group")):
		bursting()
	
	pass


