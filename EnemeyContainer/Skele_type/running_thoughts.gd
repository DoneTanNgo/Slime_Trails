extends KinematicBody2D
var max_hp = 8
var cur_hp = 8
var run_speed = 1000
var velocity = Vector2.ZERO
var direction = Vector2(1,1)
var player = null
var time = 0.0
var died = false

func _ready():
	died = true
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("spawn")
	var y = Timer.new() 
	y.set_wait_time(1) 
	add_child(y)
	y.start()
	yield(y, "timeout")
	$CollisionShape2D.disabled = false
	died = false
	$AnimationPlayer.play("running")

func _physics_process(delta):
	if(!died):
		velocity = Vector2.ZERO
		var x = 1
		if(rand_range(-1,1)>0):
			x = 1
		else:
			x = -1
		if(direction.x>0):
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		if(is_on_wall()):
			direction.y = -(direction.y)
			direction.x = -x*(direction.x)
		print(direction)
		velocity = direction * run_speed
		velocity = move_and_slide(velocity)
	
func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		died = true
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
	if(area.is_in_group("air_group")):
		global_position = Vector2(0,0)
