extends KinematicBody2D
var can_move = false

func _ready():
	$pre_laser.visible = true
	var y = Timer.new()
	y.set_wait_time(1)
	add_child(y)
	y.start()
	yield(y,"timeout")
	$fire_breath.enabled = false
	$AnimationPlayer.play("charging_up")
	yield($AnimationPlayer,"animation_finished")
	$fire_breath.enabled = true
	$fire_breath.firing_my_laser()
	y.set_wait_time(2)
	y.start()
	yield(y,"timeout")
	$fire_breath.firing_my_laser()
	queue_free()

func _physics_process(delta):
	if(can_move):
		move_and_slide(Vector2(position.x+rand_range(-200,200),position.y))
