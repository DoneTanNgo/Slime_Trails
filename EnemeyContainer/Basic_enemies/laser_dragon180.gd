extends KinematicBody2D
var can_move = false

func _ready():
	$pre_laser.visible = true
	$fire_breath.enabled = false
	
	$AnimationPlayer.play("charging_up")
	yield($AnimationPlayer,"animation_finished")
	$fire_breath.enabled = true
	$fire_breath.firing_my_laser()
	var y = Timer.new()
	y.set_wait_time(3)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$fire_breath.firing_my_laser()
	queue_free()

func _physics_process(delta):
	if(can_move):
		move_and_slide(Vector2(self.position.x,self.position.y+rand_range(-300,300)))
