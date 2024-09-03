extends Area2D
var timer = 0.0
var timer_active = false
const TIMER_TIME = 5
var speed = 50

func _ready():
	$CollisionShape2D.disabled = false
	start_timer()
	
	
func _process(delta):
	self.position += Vector2(10,0).rotated(self.rotation) * speed * delta
	if (timer_active):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			queue_free()

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func bursting()->void:
	speed = 0
	$AnimationPlayer.play("burst")
	yield($AnimationPlayer,"animation_finished")
	
	queue_free()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",10)
		bursting()
	if(area.is_in_group("wall_group")):
		bursting()
	pass

