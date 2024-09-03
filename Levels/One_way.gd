extends Position2D
var can_shoot = true
var bullet_scene = load("res://EnemeyContainer/bullets/placeholder_bullets.tscn")
var timer = 0.0
var timer_active = true
var allow_timer = true
const TIMER_TIME = 1

func _process(delta):
	if (timer_active && allow_timer):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			if(can_shoot):
				shot()
			start_timer()

func shot() -> void:
	if(can_shoot):
		can_shoot = false
		var t = Timer.new()
		t.set_wait_time(0.5)
		add_child(t)
		t.start()
		yield(t,"timeout")
		var b = bullet_scene.instance()
		owner.add_child(b)
		b.transform = self.transform
		can_shoot = true

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true
