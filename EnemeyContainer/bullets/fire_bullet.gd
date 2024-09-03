extends Area2D
var fire_scene = load("res://EnemeyContainer/bullets/fire_leftover.tscn")
var timer = 0.0
var timer_active = false
const TIMER_TIME = 4
var speed = 500
var speed_decay = 1.5


func _ready():
	start_timer()
	
func _process(delta):
	position += transform.x * speed * delta
	speed -= speed_decay
	if(speed<150):
		speed = 0
	if (timer_active):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			queue_free()


func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
	if(area.is_in_group("wall_group")):
		queue_free()
	pass
