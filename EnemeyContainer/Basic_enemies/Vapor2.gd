extends KinematicBody2D
var moving = true
var shaking = true
var velocity = Vector2.ZERO
var max_hp = 50
var cur_hp = 50
var run_speed = 250
var player = null

func _ready():
	visible = true
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

func _process(delta):
	if(moving&&shaking):
		shaking = false
		var x = rand_range(-5,5)
		var y = rand_range(-5,5)
		$Sprite.position = Vector2($CollisionShape2D.position.x+x,$CollisionShape2D.position.y+y)
		$Sprite.position = Vector2($CollisionShape2D.position.x-x,$CollisionShape2D.position.y-y)
		var t = Timer.new()
		t.set_wait_time(0.05)
		add_child(t)
		t.start()
		yield(t,"timeout")
		shaking = true

func _on_ChaseZone_body_entered(body):
	if(body.is_in_group("player_group")):
		$Sprite.frame = 1
		player = body

func _on_ChaseZone_body_exited(body):
	if(body.is_in_group("player_group")):
		$Sprite.frame = 0
		player = null


func _on_JumpScareZone_area_entered(area):
	if(area.is_in_group("player_group")):
		$AnimationPlayer.play("jumpscare")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
