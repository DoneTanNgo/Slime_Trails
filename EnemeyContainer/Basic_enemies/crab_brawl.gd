extends KinematicBody2D
var max_hp = 50
var cur_hp = 50
var run_speed = 250
var velocity = Vector2.ZERO
var player = null
var time = 0.0

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if(body.is_in_group("player_group")):
		player = body


func _on_Area2D_body_exited(body):
	if(body.is_in_group("player_group")):
		player = null
		
func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		queue_free()
	pass
